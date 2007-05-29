Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbXE2IH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbXE2IH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXE2IHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:07:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbXE2IHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:07:42 -0400
Date: Tue, 29 May 2007 10:07:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Yu <raise.sail@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070529080738.GA28657@elte.hu>
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529061544.GA28523@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > [...] in update_stats_enqueue(), It seem that these statements in 
> > two brances of "if (p->load_weight > NICE_0_LOAD)" are same, is it 
> > on purpose?
> 
> what do you mean?

you are right indeed. Mike Galbraith has sent a cleanup patch that 
removes that duplication (and uses div64_s()).

	Ingo
