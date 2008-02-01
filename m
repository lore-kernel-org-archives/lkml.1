Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYBAP4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYBAP4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYBAP4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:56:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbYBAP43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:56:29 -0500
Date: Fri, 1 Feb 2008 16:56:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6 patch] unexport touch_all_softlockup_watchdogs
Message-ID: <20080201155602.GC32085@elte.hu>
References: <20080128221452.GL8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128221452.GL8767@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the unused 
> EXPORT_SYMBOL(touch_all_softlockup_watchdogs).

NACK. Please use your brain Adrian, this is part of an API vector. 
Another similarly bogus patch you did is:

   http://lkml.org/lkml/2008/1/31/376

Either we unexport all of them, or none of them. Or we remove all 
aspects of an individual API call, or no aspects of it. You are sending 
export removal patches without apparently checking their contexts. This 
is the fourth bogus patch of yours that i've come across within a 24 
hour timeframe. Yes, sometimes unused symbol exports should be removed 
because they are just silly or unnecessary, but not all the time.

Same goes for your 'static' keyword patches. We should do it like the 
spelling fixes: send _one_ large 'add static' patch near the end of the 
release and we'll commit it without asking. Currently you are wasting a 
little bit from many people's time, by getting these tiny little "remove 
static" patches into every tree, every month, all the time. It's an 
utterly wasteful way to spend our time.

Perhaps you might want to spend some of your time to write some new, 
useful Linux kernel code and start maintaining it for a change, so that 
you can get the feel for the real problems and real issues that the 
Linux kernel is facing these days. Hint: it's not the extra exports and 
it's not the 'static' markers, and it's not the dead code either that 
you are removing so eagerly. You are not a newbie anymore.
 
	Ingo
