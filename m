Return-Path: <linux-kernel-owner+w=401wt.eu-S1763169AbXIZVNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763169AbXIZVNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762084AbXIZVNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:13:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:46795 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758062AbXIZVNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:13:42 -0400
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org, hch@lst.de,
       geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       drepper@redhat.com, subrata@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 26 Sep 2007 23:13:40 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com>
Message-ID: <20070926211340.50380@gmx.net>
MIME-Version: 1.0
References: <46FA0657.20700@gmx.net>
 <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com>
Subject: Re: Man page for revised timerfd API
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18+uzJuM/w+Y15imn9TMWyTZwOe+7/d3E+1rclgpR
 y1V6PS85w9RrCKtSFGmw6tdAq7LPEZBEKHLg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: vfPMD+ZUQEV/H5GpEnRpVqRCNzg2NYKc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

> On Wed, 26 Sep 2007, Michael Kerrisk wrote:
> 
> > .TH TIMERFD_CREATE 2 2007-09-26 Linux "Linux Programmer's Manual"
> > .SH NAME
> > timerfd_create, timerfd_settime, timer_gettime \-
> > timers that notify via file descriptors
> > .SH SYNOPSIS
> > .\" FIXME . This header file may well change
> > .\" FIXME . Probably _GNU_SOURCE will be required
> > .\" FIXME . May require: Link with \fI\-lrt\f
> > .nf
> > .B #include <sys/timerfd.h>
> > .sp
> > .BI "int timerfd_create(int " clockid );
> > .sp
> > .BI "int timerfd_settime(int " fd ", int " flags ,
> > .BI "                    const struct itimerspec *" new_value ,
> > .BI "                    struct itimerspec *" curr_value );
> > .sp
> > .BI "int timerfd_gettime(int " fd ", struct itimerspec *" curr_value );
> > .fi
> > .SH DESCRIPTION
> > These system calls create and operate on a timer
> > that delivers timer expiration notifications via a file descriptor.
> > They provide an alternative to the use of
> > .BR setitimer (2)
> > or
> > .BR timer_create (3),
> > with the advantage that the file descriptor may be monitored by
> > .BR poll (2)
> > and
> > .BR select (2).
> 
> epoll, no?

Yes, I suppose I should add it too -- I was trying to keep the 
text short was all.

[...]

And thanks for checking the other parts.

> BTW: We need to re-look over the signalfd man page, since Linus, in an 
> unexpected move, merged the simplification patch :)

Yep, I'll have the page to you in a few days.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

