Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXDUQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXDUQj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXDUQj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:39:26 -0400
Received: from holomorphy.com ([66.93.40.71]:55419 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXDUQjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:39:25 -0400
Date: Sat, 21 Apr 2007 09:39:35 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421163935.GQ31925@holomorphy.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421160008.GA28783@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 06:00:08PM +0200, Ingo Molnar wrote:
>  arch/i386/kernel/ioport.c   |   13 ++++++++++---
>  arch/x86_64/kernel/ioport.c |    8 ++++++--
>  drivers/block/loop.c        |    5 ++++-
>  include/linux/sched.h       |    7 +++++++
>  kernel/sched.c              |   40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/workqueue.c          |    2 +-
>  mm/oom_kill.c               |    4 +++-
>  7 files changed, 71 insertions(+), 8 deletions(-)

Yum. I'm going to see what this does for glxgears (I presume it's a
screensaver) on my dual G5 driving a 42" wall-mounted TV for a display. ;)

More seriously, there should be more portable ways of doing this. I
suspect even someone using fbdev on i386/x86-64 might be left out here.


-- wli
