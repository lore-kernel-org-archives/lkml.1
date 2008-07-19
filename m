Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYGSBSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYGSBSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYGSBSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:18:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYGSBSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:18:47 -0400
Date: Fri, 18 Jul 2008 21:18:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] tracing fixes
In-Reply-To: <20080718103559.GA4368@elte.hu>
Message-ID: <Pine.LNX.4.58.0807182118260.4932@gandalf.stny.rr.com>
References: <20080717173210.GA12828@elte.hu> <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com>
 <20080718084152.GJ6875@elte.hu> <20080718103559.GA4368@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jul 2008, Ingo Molnar wrote:
> ok, figured it out today: the lockups were due to the NMI watchdog and a
> missing NMI protection in cpu_clock(). I've reactivated the topic that
> solves this problem area and it all works fine now.
>
> the sched.o change probably made a difference just because it reduced
> the cross section between the NMI watchdog and the scheduler, making
> lockups less likely during the ftrace self-test. I'll revert it once the
> tracing/nmisafe is upstream.

Ingo,

Thanks a lot for looking into this.

-- Steve

