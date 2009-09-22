Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZIVMhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZIVMhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZIVMhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:37:51 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60615 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZIVMhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:37:51 -0400
Date: Tue, 22 Sep 2009 08:37:50 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: best practices:  which "uaccess.h" should one include?
In-Reply-To: <200909221409.02211.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0909220835340.31679@localhost>
References: <alpine.LFD.2.00.0909220226080.10448@localhost> <200909221409.02211.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Arnd Bergmann wrote:

> On Tuesday 22 September 2009, Robert P. J. Day wrote:
> >   philosophically, which is the "correct" uaccess.h header file to
> > include in kernel code -- <linux/uaccess.h> or <asm/uaccess.h>?
> > the first explicitly includes the second so that's a safe choice
> > but, generally, there's been a tendency to shift toward including
> > the "linux" header files.  opinion?  there's quite a mixture under
> > the drivers/ directory.
>
> The preferred one is linux/uaccess.h, the same is true for many
> headers that traditionally only existed in asm/.

  i know -- i've sent in a few patches of my own to make some of those
changes.  i just wanted to be clear since i'm writing a short tutorial
on kernel/user space copying and wanted to make the correct
recommendation for the header file to include.

> There are some headers with explicit #warning or #error messages
> when they are not included from linux/foo.h, e.g. spinlock_types.h,
> bitops.h or rwsem.h.

  yup, i've seen those, too.  thanks.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
