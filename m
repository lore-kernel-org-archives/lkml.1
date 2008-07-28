Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYG1PBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYG1PBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYG1PB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:01:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbYG1PBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:01:25 -0400
Date: Mon, 28 Jul 2008 17:01:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: mingo@redhat.com, peterz@infradead.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-<mumble> question regarding kernel/lockdep.c
Message-ID: <20080728150100.GA32111@elte.hu>
References: <42591.1216772410@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42591.1216772410@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> I was chasing after some weird behavior with lockdep, and I found that
> almost none of the printk() calls in kernel/lockdep.c have a KERN_FOO
> level specified.
> 
> It looks like it could use patching, but before I code something, I
> need to know if the patch should be doing:
> 
> a) Adding the missing KERN_FOO levels..
> or
> b) Adding a comment explaining the subtle reason they're not there...

i guess most could/should be converted to pr_info() - and a couple of 
them need to be KERN_CONT.

	Ingo
