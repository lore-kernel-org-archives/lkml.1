Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbYDORGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbYDORGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYDORGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:06:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbYDORGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:06:44 -0400
Date: Tue, 15 Apr 2008 19:05:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080415170556.GA16417@elte.hu>
References: <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins> <4803AD91.5020001@firstfloor.org> <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com> <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Why have "generic semaphores" at all, if we want to get rid of them?

i very much agree with the "get rid of semaphores" argument - the reason 
why i initially supported the "move to generic semaphores" step was 
because i saw it basically as the precursor to full removal: it is the 
removal of semaphores from all architectures - with a small generic 
compatibility wrapper to handle the remaining few uses of semaphores.

i got thoroughly surprised by the "increase the scope of semaphores" 
angle to the patchset though, and in hindsight i'd rather see neither of 
those generalizations and see semaphores die a slow but sure natural 
death than to see their prolongation :-/

perhaps the 'remove all semaphores from all architectures' privilege 
should be a final step kept for the lucky guy who manages to get rid of 
the last remaining semaphore use in the kernel? :)

	Ingo
