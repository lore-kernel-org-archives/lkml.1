Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbYELITi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbYELITi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 04:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELITb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 04:19:31 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:37947 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbYELITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 04:19:30 -0400
Date: Mon, 12 May 2008 04:19:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KCONFIG: With a simple menuconfig, kernel debugging is
 prettier.
In-Reply-To: <20080506135844.b0b12d05.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805120417200.25000@localhost.localdomain>
References: <alpine.LFD.1.10.0804241928340.20003@localhost.localdomain> <20080506135844.b0b12d05.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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

On Tue, 6 May 2008, Andrew Morton wrote:

> On Thu, 24 Apr 2008 19:31:26 -0400 (EDT)
> "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>
> > Implementing kernel debugging with a menuconfig allows for the removal
> > of a pile of unnecessary dependencies.
>
>  Kconfig.debug |  112 +++++++++++++++++++++++++---------------------------------
>  1 file changed, 49 insertions(+), 63 deletions(-)
>
> I'm afraid,
>
> akpm:/usr/src/25> grep -l lib/Kconfig.debug pc/*.pc
> pc/documentation-build-source-files-in-documentation-sub-dir-disable.pc
> pc/documentation-build-source-files-in-documentation-sub-dir.pc
> pc/git-sched.pc
> pc/git-x86-latest.pc
> pc/linux-next.pc
> pc/make-frame_pointer-default=y.pc
> pc/mm-add-a-basic-debugging-framework-for-memory-initialisation.pc
> pc/mutex-subsystem-synchro-test-module.pc
> pc/page-owner-tracking-leak-detector.pc
> pc/profile-likely-unlikely-macros.pc
> pc/slab-leaks3-default-y.pc
>
> that our chances of finding a window in which to merge this patch
> are pretty darn small.

fair enough, but is there any sort of reorg that can be done with the
kernel debugging menu?  it really is getting a bit out of hand.  at
the very least, could it be collected into related categories?

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
