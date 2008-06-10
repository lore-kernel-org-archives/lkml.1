Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbYFJKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbYFJKEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYFJKEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:04:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYFJKEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:04:36 -0400
Date: Tue, 10 Jun 2008 12:04:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Extend percpu ops to 64 bit
Message-ID: <20080610100411.GJ27706@elte.hu>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.299510000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604003019.299510000@polaris-admin.engr.sgi.com>
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

>   * x86 percpu ops now will work on 64 bit too, so add the missing 8 byte cases.
> 
>   * Add a few atomic ops that will be useful in the future:
> 
> 	x86_xchg_percpu()
> 	x86_cmpxchg_percpu().
> 
> 	x86_inc_percpu() - Increment by one can generate more efficient
> 	x86_dec_percpu()   instructions and inc/dec will be supported by
> 			   cpu ops later.
> 
>   * Use per_cpu_var() instead of per_cpu__##xxx.
> 
> Based on linux-2.6.tip

applied to tip/cpus4096, thanks Mike.

	Ingo
