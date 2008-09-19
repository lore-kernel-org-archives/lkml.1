Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYISIFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYISIFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYISIFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:05:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbYISIFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:05:37 -0400
Date: Fri, 19 Sep 2008 10:05:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - restore_IO_APIC_setup NULL
	pointer quick fix
Message-ID: <20080919080520.GA19491@elte.hu>
References: <20080918193757.GB7294@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918193757.GB7294@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Check if memory was granted first - we don't like NULL deref.
> It's a *quick* fix. Actually it's better to hadle this error
> at moment of memory allocation. It's save_mask_IO_APIC_setup
> route who allocates this memory (just for the record).
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> I'll handle this in _normal_ way tomorrow. Please review.

ok, i've applied the quick fix to tip/master - the patch will drop from 
there on the next integration run.

	Ingo
