Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYJWOY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYJWOY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYJWOYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:24:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYJWOYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:24:49 -0400
Date: Thu, 23 Oct 2008 16:24:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
	cpumask
Message-ID: <20081023142425.GB22088@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu> <490088BD.1060606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490088BD.1060606@sgi.com>
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

> Ingo Molnar wrote:
> > ok, the new cpumask code blew up in -tip testing, with various sorts of 
> > slab corruptions during scheduler init:
> > 
> ...
>
> Curious thing happens here.  I created the tree as you suggested 
> (branch tip/cpus4096-v2) and copied in your .config file.  Running it 
> through "silentoldconfig" (choosing only the defaults), I get the 
> following changes.  This makes me suspect that I'm not testing the 
> same thing as you are...?  Perhaps my git setup was not correct?

no - i have some extras that forces on SMP for example to make it more 
likely to trigger in random tests (it's far more interesting from a QA 
point of view than UP).

so as long as you select SMP you should get the same config. Lemme do a 
.config you can plug in.

	Ingo
