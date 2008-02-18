Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYBRJum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYBRJum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYBRJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:50:29 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:54737 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYBRJu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:50:27 -0500
Date: Mon, 18 Feb 2008 04:50:20 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Valdis.Kletnieks@vt.edu
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/hdsmart.h: fix goofups
In-Reply-To: <30744.1203311197@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.1.00.0802180449430.13823@localhost.localdomain>
References: <200802171807.57983.bzolnier@gmail.com>            <alpine.LFD.1.00.0802171214380.3515@localhost.localdomain> <30744.1203311197@turing-police.cc.vt.edu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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

On Mon, 18 Feb 2008, Valdis.Kletnieks@vt.edu wrote:

> On Sun, 17 Feb 2008 12:17:20 EST, "Robert P. J. Day" said:
>
> > if that header file isn't used by any kernel code, why bother having a
> > check for __KERNEL__ in the first place?  it's being exported to
> > userspace unchecked:
> >
> >   include/linux/Kbuild:header-y += hdsmart.h
> >
> > so why not just toss that check entirely?  otherwise, you're going to
> > get a header file exported to userspace that has a superfluous
> > __KERNEL__ test in it.
>
> Umm... if the kernel isn't using it, why are we bothering to export
> it to userspace at all?  Or is the kernel using something *else*
> that should be going to userspace instead?

beats me, i just observe 'em, i don't make those judgment calls.  :-)

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
