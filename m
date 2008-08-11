Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYHKKIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYHKKIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYHKKIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:08:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYHKKIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:08:36 -0400
Date: Mon, 11 Aug 2008 12:08:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 0/7] lockdep
Message-ID: <20080811100807.GA8184@elte.hu>
References: <20080804130317.994042639@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804130317.994042639@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Hi,
> 
> This series is my pending lockdep queue, it includes David's graph 
> optimization, my new scheduler runqueue annotation amongst others.
> 
> The part that makes this RFC are the latter few patches that add the 
> "lock protection locks" thing Linus proposed a few days ago. I've not 
> yet written a test case that actively tests this functionality, but 
> wanted to get this out so that Jeremy can see if it works for him.

update: i'm now back from vacation and i've added these patches to 
tip/core/locking, but -tip testing found a few problems with them so i 
wont push them upstream yet.

	Ingo
