Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbXGQOk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbXGQOk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbXGQOks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:40:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:6581 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbXGQOkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sZsASTpO114oCWkRgzuIAfbdAxJnUD7B0wNqV6Va9WnA8VJySzUzrqxxUkAEcUhpSZjoGACesGXyW0eq6DZXuXFgRV4VFuPFhng+xHpWcMjfRb3cBjDh4NU9GwW1ZXrA0R0mHCKQoVSIoF0UyEcETiVmKc9XEBRSzAI9zI7j7vE=
Message-ID: <86802c440707170740i30ed2110l130dafbec8e4d4a5@mail.gmail.com>
Date: Tue, 17 Jul 2007 07:40:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Cc: "Aaron Durbin" <adurbin@google.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, akpm@osdl.org
In-Reply-To: <200707171331.59414.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180019.GA5112@google.com> <200707171331.59414.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 16 July 2007 20:00:19 Aaron Durbin wrote:
> >
> > Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
>
> Why? I had such a patch at some point as experiment, but it never
> helped actually fix a box.
>
system without superio, should still have SMI to simulate one keyboard
controller. So the key board reset still works.

YH
