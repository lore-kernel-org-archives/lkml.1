Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbZDQQ3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbZDQQ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761380AbZDQQ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:28:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761710AbZDQQ2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:28:50 -0400
Date: Fri, 17 Apr 2009 18:28:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] tracing/filters: add filter_mutex to protect filter
	predicates
Message-ID: <20090417162841.GI8253@elte.hu>
References: <1239946028.6639.13.camel@tropicana> <49E814E2.4000600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E814E2.4000600@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Tom Zanussi wrote:
> > This patch adds a filter_mutex to prevent the filter predicates from
> > being accessed concurrently by various external functions.
> > 
> > It's based on a previous patch by Li Zefan:
> >         "[PATCH 7/7] tracing/filters: make filter preds RCU safe"
> > 
> > v2 changes:
> > 
> > - fixed wrong value returned in a add_subsystem_pred() failure case
> > noticed by Li Zefan.
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > 
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>

Applied, thanks guys!

	Ingo
