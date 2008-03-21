Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYCUMM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYCUMM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYCUMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:12:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60697 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbYCUMMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:12:17 -0400
Date: Fri, 21 Mar 2008 13:12:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: 2.6.25-rc5-mm1
Message-ID: <20080321121205.GG25225@elte.hu>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <20080311202300.GA8957@vino.hallyn.com> <20080311133920.68dc410b.akpm@linux-foundation.org> <64bb37e0803121233v30d12a58i77a1e23fd02ea6f2@mail.gmail.com> <20080312124420.3ba8c3d7.akpm@linux-foundation.org> <64bb37e0803121301u6f836710m9ebb30e065751bec@mail.gmail.com> <64bb37e0803131505u7ae920fdvbbed005cbeb8c98e@mail.gmail.com> <20080313153528.a11795b7.akpm@linux-foundation.org> <1205449809.19403.40.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205449809.19403.40.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1844]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Badari Pulavarty <pbadari@gmail.com> wrote:

> Yes. I found the following patch to be the culprit.
> 
> sched: make sure jiffies is up to date before calling __update_rq_clock
> ()

thanks Badari, i've backed out this patch.

	Ingo
