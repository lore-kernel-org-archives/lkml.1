Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZITRFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZITRFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZITRFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:05:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbZITRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:05:34 -0400
Date: Sun, 20 Sep 2009 10:05:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timers/timekeeping for 2.6.32
In-Reply-To: <20090920074706.GA32245@elte.hu>
Message-ID: <alpine.LFD.2.01.0909201004560.4950@localhost.localdomain>
References: <alpine.LFD.2.00.0909161555360.8957@localhost.localdomain> <20090920074706.GA32245@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 Sep 2009, Ingo Molnar wrote:
>
> When pulling this you did a merge resolution to 
> arch/mips/loongson/common/time.c in commit a03fdb761, but it looks 
> suspicious:
> 
>  void read_persistent_clock(struct timespec *ts)
>  {
>          ts->tv_sec = return mc146818_get_cmos_time();
>          ts->tv_nsec = 0;
>  }
> 
> that 'return' looks stray, so shouldnt we do the fix below?

Duh. Too much mousing around to cut-and-paste crap.

		Linus
