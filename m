Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbYBMNE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbYBMNE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYBMNEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:04:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYBMNEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:04:48 -0500
Date: Wed, 13 Feb 2008 14:04:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] 2.6.25-rc1 does not boot on Alpha
Message-ID: <20080213130432.GE6344@elte.hu>
References: <20080213052903.B1F1CDBA2@gherkin.frus.com> <20080213092208.GC21614@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213092208.GC21614@elte.hu>
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

> > Unless someone has a good idea what's causing this, I see a massive 
> > "git bisect" project in my future.  Won't be able to spend any time 
> > with this until at least the weekend :-(.
> 
> hm, is this SMP? Alpha uses asm-generic/percpu.h. One "early bootup" 
> effect on Alpha that i can think of could have been this family of 
> commits:

another possibility would be to turn off PRINTK_TIMESTAMPS [if they are 
on in your .config].

	Ingo
