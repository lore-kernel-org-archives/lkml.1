Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXC1Lpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXC1Lpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 07:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXC1Lpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 07:45:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965526AbXC1Lpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 07:45:53 -0400
Date: Wed, 28 Mar 2007 13:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] scheduler: strange behavor with massive interactive processes
Message-ID: <20070328114540.GA7942@elte.hu>
References: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com> <1174971852.16403.35.camel@Homer.simpson.net> <1175071091.29829.58.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175071091.29829.58.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> +	struct task_struct *p = NULL; 

(small nit: extra space at the end of line.)

> +				rq->best_expired_prio = MAX_PRIO;
> +#if 0
> +				rq->switch_timestamp = jiffies;
> +#endif

remove this chunk? (i dont think we want to touch switch_timestamp here)

	Ingo
