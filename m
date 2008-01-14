Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYANIAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYANIAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYANH7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 02:59:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYANH7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 02:59:53 -0500
Date: Mon, 14 Jan 2008 08:59:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Dillow <dillowda@ornl.gov>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080114075922.GA17686@elte.hu>
References: <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <20080111122802.GT6258@kernel.dk> <20080111132106.GA16496@elte.hu> <20080111171855.GX6258@kernel.dk> <20080114075114.GA13195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114075114.GA13195@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> because a perfectly working system is:
> 
>  "a user's .config that worked before should work with the new kernel
>   too"
> 
> not:
> 
>  "a user's .config that worked before should work now too, with random
>   new kernel features enabled as well."
> 
> the latter appears to be the rule you are applying, but it's not the 
> regression rule we are using.

Jens, just to bring your definition of regressions to its logical 
conclusion: does this mean that if there is any longstanding bug in the 
block layer that you know about, but i didnt ever utilize that bit of 
the block layer it in my .config, and if i enable it now in the .config 
and i experience that bug, does it suddenly count as a regression? Do 
you realize that your definition for "regressions" turns _almost every_ 
current bug in the kernel into a regression?

	Ingo
