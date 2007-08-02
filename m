Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXHBK3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXHBK3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbXHBK3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:29:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59612 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbXHBK3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:29:20 -0400
Date: Thu, 2 Aug 2007 12:29:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Tidy up left over smpnice code after changes
	introduced with CFS
Message-ID: <20070802102913.GB26377@elte.hu>
References: <46B17AA3.80906@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B17AA3.80906@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5231]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> 1. The only place that RTPRIO_TO_LOAD_WEIGHT() is used is in the call 
> to move_tasks() in the function active_load_balance() and its purpose 
> here is just to make sure that the load to be moved is big enough to 
> ensure that exactly one task is moved (if there's one available).  
> This can be accomplished by using ULONG_MAX instead and this allows 
> RTPRIO_TO_LOAD_WEIGHT() to be deleted.
> 
> 2. This, in turn, allows PRIO_TO_LOAD_WEIGHT() to be deleted.
> 
> 3. This allows load_weight() to be deleted which allows 
> TIME_SLICE_NICE_ZERO to be deleted along with the comment above it.

thanks, i've added this to my tree.

	Ingo
