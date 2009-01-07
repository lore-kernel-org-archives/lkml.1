Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbZAGUw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbZAGUw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZAGUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:52:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZAGUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:52:50 -0500
Date: Wed, 7 Jan 2009 21:52:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] cpumask: more cpumask updates
Message-ID: <20090107205229.GB4597@elte.hu>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107195832.265117000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> 
> One big change to irq_desc and a few smaller maintenance type updates.
> 
> 	cpumask: update irq_desc to use cpumask_var_t
> 	cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
> 	cpumask: convert misc driver functions
> 	cpumask: convert drivers/net/sfc
> 	cpumask: convert other misc kernel functions
> 
> Based on tip/cpus4096: v2.6.28-5703-g1d1a70e
> 
> (Ingo - I added a blank line before the From: part and that seems to
> separate it from the Subject.  Hopefully your git-am will still
> recognizes it - I did try a git-am here and it seemed to work ok.)
> 
> Signed-off-by: Mike Travis <travis@sgi.com>

Since you have it in a Git tree, why dont you send me a pull request?

I might be more picky about pull requests in general (because it's harder 
to fix up a pulled tree than to fix up commits that come from emails - and 
it's also more work for you if i refuse to pull than if i have some 
comments over email-patches), but it's a much better (more scalable) 
workflow in the long run than the email path.

	Ingo
