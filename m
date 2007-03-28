Return-Path: <linux-kernel-owner+w=401wt.eu-S965539AbXC1Lh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbXC1Lh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 07:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965543AbXC1Lh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 07:37:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965539AbXC1Lhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 07:37:55 -0400
Date: Wed, 28 Mar 2007 13:37:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: malc <av1474@comtv.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: accurate user accounting
Message-ID: <20070328113743.GA5615@elte.hu>
References: <200703251159.03616.kernel@kolivas.org> <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org> <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
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


* malc <av1474@comtv.ru> wrote:

> This situation is harder to write a hog-like testcase for. Anyhow it 
> seems the difference in percentage stems from the `intr' field of 
> `/proc/stat', which fits. And following patch (which should be applied 
> on top of yours) seems to help. I wouldn't really know what to do with 
> softirq and the rest of counts touched by this function, so i left 
> them alone.
> 
> Comments?

i like it. FYI, i've applied your patch to -rt.

	Ingo
