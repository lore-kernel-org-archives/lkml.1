Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbXEWFlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbXEWFlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 01:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXEWFlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 01:41:15 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:18790 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbXEWFlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 01:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RvEVFdvmRqJj72HIqaonJBVkCdrxG6899YudDSJcEVW/ILb8P72PAFJqjIJsIle4nqOoVqhuuDk6/Z9FykGxRZ11da6kZMsbqNRZypzds0CF1htKIqJKw8pxtr9FJnjvNymJYjbE9WtEh3PYbEIaxforcwL7Jb5CnRRgiF5hX6o=
Message-ID: <6d4bc9fc0705222241y5627d992g84aa720abb9d8cdd@mail.gmail.com>
Date: Wed, 23 May 2007 07:41:13 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [realtime kernel 2.6.21-rt2 and up] Extremely slow bootup for x86_64
Cc: "Frank Sorenson" <frank@tuxrocks.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1179763474.12708.7.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d4bc9fc0705200525m1b72aaaevf8a1d090038bb7dc@mail.gmail.com>
	 <1179669982.21827.25.camel@chaos> <46512778.2050205@tuxrocks.com>
	 <1179725216.6570.32.camel@chaos> <4651B6A7.1060901@tuxrocks.com>
	 <1179763474.12708.7.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.21-rt6 is working normally as far as i can see.

Maarten.

On 5/21/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 2007-05-21 at 10:11 -0500, Frank Sorenson wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Thomas Gleixner wrote:
> > > On Mon, 2007-05-21 at 00:00 -0500, Frank Sorenson wrote:
> > >
> > >> I see the slow bootup as well, even with 2.6.22-rc2-hrt1.  It takes at
> > >> least 5 times as long to boot, for X to start, to login, etc.
> > >
> > > Can you provide me your .config and a boot log (please enable
> > > CONFIG_PRINTK_TIME and add "apic=verbose" to the kernel command line).
> > >
> > > Can you also try with "hpet=disable" ?
> >
> > All attached.  With "hpet=disable", it's still slow (clocksource becomes
> > acpi_pm).
>
> > [   23.159166] Bluetooth: HCI device and connection manager initialized
> > [   23.159170] Bluetooth: HCI socket layer initialized
> > [   23.159179] BUG: at mm/slab.c:777 __find_general_cachep()
> > [   23.159181]
> > [   23.159182] Call Trace:
> > [   23.159190]  [<ffffffff81097a67>] __kmalloc+0xa7/0xe0
> > [   23.159195]  [<ffffffff810238dd>] cache_k8_northbridges+0x9d/0x120
> > [   23.159200]  [<ffffffff814ddce3>] gart_iommu_init+0x33/0x5b0
> > [   23.159205]  [<ffffffff811d4027>] class_register+0x177/0x180
> > [   23.159210]  [<ffffffff814d8379>] pci_iommu_init+0x9/0x20
> > [   23.159214]  [<ffffffff814cf6cc>] kernel_init+0x14c/0x320
> > [   23.159218]  [<ffffffff8100b1b8>] child_rip+0xa/0x12
> > [   23.159223]  [<ffffffff81184150>] acpi_ds_init_one_object+0x0/0x7c
> > [   23.159227]  [<ffffffff814cf580>] kernel_init+0x0/0x320
> > [   23.159230]  [<ffffffff8100b1ae>] child_rip+0x0/0x12
>
> Hmm, other than this gem there is nothing obvious in the boot log. Does
> the box boot normal with 2.6.22-rc2 ?
>
> Where does the slowness start ? Right from the beginning or later in the
> boot process ?
>
>         tglx
>
>
>
