Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbYFNJAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbYFNJAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbYFNJAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:00:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbYFNJAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:00:34 -0400
Date: Sat, 14 Jun 2008 11:00:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Message-ID: <20080614090023.GA13798@elte.hu>
References: <20080613140057.GA25833@damson.getinternet.no> <20080614063114.GA24188@elte.hu> <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> http://git.kernel.org/?p=linux/kernel/git/vegard/kmemcheck.git;a=commit;h=8c67b9b8005a518ce003943a64c37a9fc2c84485
> 
> But for the newer versions, I've merged it into the "kmemcheck core" 
> commit. To pick up the whole series, you can either check out the 
> against-v2.6.26-rc5 branch (which is frozen), or you can check out the 
> "current" branch which is the most recent rebase (against v2.6.26-rc6, 
> but not yet frozen):

a small workflow request: could you please start adding append-only 
commits to that tree, if possible? For example right now as it looks the 
kmemcheck tree says:

 commit 385e31b9eae0528bada07d16a189f3f40df23961
 Author: Vegard Nossum <vegard.nossum@gmail.com>
 Date:   Fri Apr 4 00:51:41 2008 +0200

     kmemcheck: add the kmemcheck core

i had to look around for a few minutes to make sure i got the right 
branch until i realized that "Apr 4" is not the correct date - this 
commit got updated by you just today.

it would be much better if you stopped rebasing kmemcheck from now on, 
and did append-only updates only - that way i could pick up your updates 
into tip/kmemcheck by doing pulls. It does not matter if the result 
looks a bit messier - most of the fundamentals should be in place 
already.

	Ingo
