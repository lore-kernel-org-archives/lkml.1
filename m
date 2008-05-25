Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYEYSzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYEYSzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYEYSzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:55:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46022 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbYEYSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:55:07 -0400
Date: Sun, 25 May 2008 11:53:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
Message-ID: <20080525115305.79c12c8c@infradead.org>
In-Reply-To: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 23:11:20 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> In git commit 35d5d08a085c56f153458c3f5d8ce24123617faf, Andrew Morton
> placed preempt_disable around the entire delay due to TSC's not
> working nicely on SMP.  Unfortunately for those that care about
> latencies this is devastating! Especially when we have callers to
> mdelay(8).

we used to have a WARN_ON if mdelay was called while preemptable..
maybe we should put that back in?
