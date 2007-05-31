Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbXEaStQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbXEaStQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbXEaStF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:49:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:26928 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbXEaStD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WlumsF4dGJb2rRuDKJmQ0ETANNJFGBKSBP8rmIKK7KJxXDTUZBX/U7u6R6OEuSNcZDnf/4C3yn1F2QO4ns8nEBo5Hdu6kYZJy7uWyqvIJ9dzC/M4yhxy9qE4CU6+Ba0OsYJLcLhjlVly4GxuyVoYrnm1huI29TcNSPyV3KWLebc=
Message-ID: <86802c440705311149y727e734ftc17c05e13ace74c9@mail.gmail.com>
Date: Thu, 31 May 2007 11:49:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705311045.36411.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705291844.00308.yinghai.lu@sun.com>
	 <200705310917.19205.bjorn.helgaas@hp.com>
	 <86802c440705310932x3c85d9eao109fcf6445bd5938@mail.gmail.com>
	 <200705311045.36411.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > not really.
>
> I'm sorry, I don't understand the point you're making.
>
> Andrew's proposal was that we could add early_uart_ioremap to the list of
> bt_ioremap and dmi_ioremap.
>

for i386, bt_ioremap is using fixmap, and it is temporary boot-time
mappings, used before ioremap() is functional.
but we need one as permanent fixed address.

for x86_64, early_ioremap. I'd like to make to static, because
dmi_ioremap could use ioremap instead.

Fix address could make the earlycon can be used more earlier.

YH
