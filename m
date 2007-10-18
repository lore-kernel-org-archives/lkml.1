Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbXJRTjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbXJRTjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbXJRTjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:39:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbXJRTjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:39:35 -0400
Date: Thu, 18 Oct 2007 21:39:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
Message-ID: <20071018193929.GA22031@elte.hu>
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu> <20071018192521.GC21136@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018192521.GC21136@shadowen.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@shadowen.org> wrote:

> > it's perfectly legitimate, in fact more robust. So if checkpatch.pl 
> > wants to make any noise about such constructs it should warn about 
> > the _lack_ of curly braces in every multi-line condition block 
> > _except_ the only safe single-line statement:
> > 
> > 	if (x)
> > 		y();
> 
> Indeed.  We should probabally do more on the indentation checks in
> general.  The current direct check for:
> 
> 	if (foo);
> 		bar();
> 
> Could probabally be generalised to look for this kind of error:
> 
> 	if (foo)
> 		bar();
> 		baz();
> 	one();

detecting that would be awesome - it's often the sign of a real bug 
because the intent is often to have bar() and baz() in the conditional 
block.

	Ingo
