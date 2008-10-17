Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYJQK1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYJQK1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYJQK04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:26:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYJQK0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:26:55 -0400
Date: Fri, 17 Oct 2008 12:26:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: fix the wrong mask_len
Message-ID: <20081017102642.GA11865@elte.hu>
References: <48F8664A.2000205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F8664A.2000205@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4289]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miao Xie <miaox@cn.fujitsu.com> wrote:

> If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
> domains by catting /proc/schedstat. This is caused by the wrong mask_len.
> 
> This patch fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

applied to tip/sched/urgent, thanks!

	Ingo
