Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXJ2QN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXJ2QN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXJ2QNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:13:20 -0400
Received: from www.tglx.de ([62.245.132.106]:42265 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbXJ2QNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:13:19 -0400
Date: Mon, 29 Oct 2007 17:13:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
In-Reply-To: <472602D3.4010007@zytor.com>
Message-ID: <alpine.LFD.0.9999.0710291712480.3186@localhost.localdomain>
References: <200710290628.l9T6SDpo012530@harpo.it.uu.se> <alpine.LFD.0.9999.0710291440570.3186@localhost.localdomain> <472602D3.4010007@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, H. Peter Anvin wrote:
> Thomas Gleixner wrote:
> > > 
> > > They look like paths to the vmlinuz and initrd surrounded
> > > by [ ] brackets, so I guess they come from grub.
> > 
> > Any chance to use serial console ?
> > 
> > Enable CONFIG_EARLY_PRINTK and add
> >  earlyprintk=serial,ttyS0,115200,keep
> > 
> > to the kernel command line.
> > 
> > Can you please provide your .config file ?
> > 
> 
> I doubt he's getting far enough that he's actually getting early printk.  I
> could be wrong, of course.
> 
> > I tested on my i386 box and Linus latest git boots fine:
> > # uname -a
> > Linux museum386 2.6.24-rc1-2a397e82 #1 PREEMPT Mon Oct 29 13:39:29 CET 2007
> > i386 unknown
> > # cat /proc/cpuinfo
> > clflush size    : 32
> 
> Hm.  This probably shouldn't be displayed when clflush isn't available...

Yup, I noticed as well :)

     tglx
