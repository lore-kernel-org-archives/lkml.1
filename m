Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYG1QG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYG1QG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYG1QGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:06:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYG1QGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:06:48 -0400
Date: Mon, 28 Jul 2008 18:06:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Borisov <niro@tut.by>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] fix warning in arch/x86/mm/pgtable.c
Message-ID: <20080728160630.GA17669@elte.hu>
References: <1217091007.6107.8.camel@inlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1217091007.6107.8.camel@inlin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0311]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Borisov <niro@tut.by> wrote:

> This patch fixes the following compile warning:
> 
> arch/x86/mm/pgtable.c: In function ‘pgd_mop_up_pmds’:
> arch/x86/mm/pgtable.c:194: warning: unused variable ‘pmd’

> -               pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|
> __GFP_REPEAT);
> +               pmd_t *pmd;
> +               pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);

what gcc version are you using? Seems to be a compiler bug.

	Ingo
