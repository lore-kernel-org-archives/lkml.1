Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYG2Sf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYG2Sf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYG2SfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:35:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:24161 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYG2SfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=efreLPr5JMW9vqLz9Hbycwmssw7YMnu1F0GnbfT74XaZ1H2BBVPuo+gtML3IU5TfNw
         ztfsTmIptDfat8eaD30PcSJ3bfX1N924UwYfEjqAu35z4WSnKUh/6iXq99G17k0M1YVo
         O6eXsAy0o0WdendfKoovDg0vUKGDk0c3gxlQM=
Message-ID: <86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
Date: Tue, 29 Jul 2008 11:35:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080729160939.GA4484@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729160939.GA4484@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 9:09 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> Hi Ingo, Thomas,
>
> Hit this on 2.6.27-rc1
>
> (The kernel bug is at line 356 (Its 357 as I applied a debug patch to
> print out the irq) (Full dmesg and .config attached)

can you boot with "debug apic=verbose pci=routeirq"?

YH
