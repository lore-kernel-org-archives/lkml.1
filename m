Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZIXNM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZIXNM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZIXNM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:12:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZIXNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:12:57 -0400
Date: Thu, 24 Sep 2009 15:12:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: fix buffer allocation
Message-ID: <20090924131250.GA15132@elte.hu>
References: <4ABB6EB7.7000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABB6EB7.7000002@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1692]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Hi Ingo
> 
> Here is a patch for perf.

Applied, thanks Eric!

> BTW, use of openat() is a nuisance, since many machines have old glibc
> (RHEL 4 Update 5 -> glibc-2.3.4-2.36 on my dev machine for example)

We can certainly remove that reliance - wanna send a patch for it?

	Ingo
