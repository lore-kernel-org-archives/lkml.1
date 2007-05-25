Return-Path: <linux-kernel-owner+w=401wt.eu-S1763485AbXEYQSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763485AbXEYQSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXEYQS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:18:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbXEYQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:18:27 -0400
Date: Fri, 25 May 2007 09:17:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Satyam Sharma <satyam.sharma@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-Id: <20070525091743.5fb569a8.akpm@linux-foundation.org>
In-Reply-To: <20070525121540.GA24083@one.firstfloor.org>
References: <20070525015544.bce3cb99.akpm@linux-foundation.org>
	<20070525090315.GK8094@one.firstfloor.org>
	<20070525091928.GA3177@elte.hu>
	<20070525094640.GL8094@one.firstfloor.org>
	<20070525101248.GA7547@elte.hu>
	<20070525112020.GN8094@one.firstfloor.org>
	<20070525112600.GA27007@elte.hu>
	<20070525115004.GA4574@elte.hu>
	<20070525115544.GP8094@one.firstfloor.org>
	<20070525120228.GA7186@elte.hu>
	<20070525121540.GA24083@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 14:15:40 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> -Andi (who hopes this thread will end soon now and we can all go
> back to more important issues)

fyi, the thread has been damn useful for me.  If Ingo hadn't spotted that
preempt_count() imbalance then there's a decent chance that I'd have been
the first to hit it.

Time to bisect 1,000 patches: maybe an hour, if I choose the x86 tree as
the first pivot point, which is likely.

Or I wouldn't have hit it, in which case a tester hits it, and someone
(guess who) gets to enter into an intercontinental head-scratching session
trying to work out who broke it this time, consuming the tester's time too.
Plus we have a wrecked -mm and other people's code doesn't get as
well-tested as it might.

All for one silly little mistake.


So.  More care, please.

