Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYJWLBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYJWLBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYJWLA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:00:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYJWLA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:00:56 -0400
Date: Thu, 23 Oct 2008 13:00:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/35] cpumask: cpumask_any_but() From: Rusty Russell
	<rusty@rustcorp.com.au>
Message-ID: <20081023110036.GA25132@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020830.882924000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023020830.882924000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> +int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
> +{
> +	unsigned int i;
> +
> +	for_each_cpu(i, mask)
> +		if (i != cpu)
> +			break;
> +	return i;
> +}
> +
>  /* These are not inline because of header tangles. */

i've added a missing export here.

	Ingo
