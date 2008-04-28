Return-Path: <linux-kernel-owner+w=401wt.eu-S936126AbYD1T6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936126AbYD1T6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765616AbYD1T6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:58:17 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:16170 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765483AbYD1T6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:58:16 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
From: Andi Kleen <andi@firstfloor.org>
References: <1209327591.14173.74.camel@brick>
	<alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org>
Date: Mon, 28 Apr 2008 21:57:33 +0200
In-Reply-To: <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org> (Linus Torvalds's message of "Mon, 28 Apr 2008 09:54:37 -0700 (PDT)")
Message-ID: <874p9liwgi.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 19:50:41.0152 (UTC) FILETIME=[2373F000:01C8A969]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Is there a real hot path anywhere that actually uses this and depends on 
> it?

A long time ago during profiling I found that in the scheduler back then
for_each_cpu() with find_next_bit() was somewhat hot. But I'm not sure it 
still would be in the new scheduler anyways and the test case a little
dumb anyways (overscheduling user space)

Still I think for_each_cpu() should be reasonably stream lined code.

-Andi
