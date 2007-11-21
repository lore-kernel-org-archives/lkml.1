Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXKUIyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXKUIyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXKUIy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:54:28 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:55850 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXKUIy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:54:27 -0500
Date: Wed, 21 Nov 2007 03:52:08 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Avi Kivity <avi@qumranet.com>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
In-Reply-To: <4743EFF8.9010307@qumranet.com>
Message-ID: <alpine.LFD.0.9999.0711210350050.10132@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743EB52.1040205@linux.vnet.ibm.com> <20071120163240.e54beed6.akpm@linux-foundation.org> <4743EF47.5000203@linux.vnet.ibm.com> <4743EFF8.9010307@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Avi Kivity wrote:

> Kamalesh Babulal wrote:
> > Andrew Morton wrote:
> >
> > > On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal
> > > <kamalesh@linux.vnet.ibm.com> wrote:
> > >
> > >
> > > > The make headers_check fails,
> > > >
> > > >   CHECK   include/linux/usb/gadgetfs.h
> > > >   CHECK   include/linux/usb/ch9.h
> > > >   CHECK   include/linux/usb/cdc.h
> > > >   CHECK   include/linux/usb/audio.h
> > > >   CHECK   include/linux/kvm.h
> > > > /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires
> > > > asm/kvm.h, which does not exist in exported headers
> > > >
> > > hm, works for me, on i386 and x86_64.  What's different over there?
> > >
> > Hi Andrew,
> >
> > It fails on the powerpc box, with allyesconfig option.
>
> How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.

i'm sure i'm going to humiliate myself for asking this, but shouldn't
i be able to reproduce the above by just running:

  $ make ARCH=powerpc headers_install/headers_check

we've sort of had this discussion before where, IIRC, you should be
able to generate the appropriate arch-specific headers without having
the corresponding toolchain, no?  so why can't i reproduce that error
on my x86 box?

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
