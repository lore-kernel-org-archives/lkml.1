Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYA3QNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYA3QNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYA3QNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:13:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbYA3QNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:13:12 -0500
Date: Wed, 30 Jan 2008 17:13:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerald Stralko <gerb.stralko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: remove unused params
Message-ID: <20080130161302.GB12293@elte.hu>
References: <alpine.LRH.1.00.0801301048570.23744@buckthorn.lexi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.00.0801301048570.23744@buckthorn.lexi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1364]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gerald Stralko <gerb.stralko@gmail.com> wrote:

> This removes the extra struct task_struct *p parameter in inc_nr_running 
> and dec_nr_running functions.

> -static void inc_nr_running(struct task_struct *p, struct rq *rq)
> +static void inc_nr_running(struct rq *rq)
>  {
>  	rq->nr_running++;

thanks, applied.

	Ingo
