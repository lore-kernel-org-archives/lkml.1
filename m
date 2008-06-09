Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYFIQQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYFIQQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYFIQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:16:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYFIQQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:16:40 -0400
Date: Mon, 9 Jun 2008 18:16:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Message-ID: <20080609161606.GA24841@elte.hu>
References: <200805252108.25011.mitov@issp.bas.bg> <200806011901.23619.mitov@issp.bas.bg> <20080609121309.GA13610@elte.hu> <200806091911.21850.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806091911.21850.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marin Mitov <mitov@issp.bas.bg> wrote:

> > i think Thomas had a concern with the original fix - forgot the 
> > details.
> 
> Here they are:
> 
> http://lkml.org/lkml/2008/5/25/251
> 
> but see my comment to it.
> 
> There is no principal difference between both patches. I have seen 
> Steven's one as merged in linux-2.6.26-rc5. The only difference (if it 
> matters of all) is that in mine patch 
> preempt_disable()/preempt_enable() sections are shorter and protect 
> only the code that must be protected:
> 
> preempt_disable()
> rdtscl()
> smp_processor_id()
> preempt_enable()
> 
> As far as Steven's patch is already merged - let it be :-)

we could still merge your enhancements as well ontop of Steven's, if you 
would like to pursue it. If so then please send a patch against -rc5 or 
against -tip. Reducing the length of preempt-off sections is a fair 
goal.

	Ingo
