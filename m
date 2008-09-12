Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYILJG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYILJG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYILJGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:06:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYILJGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:06:19 -0400
Date: Fri, 12 Sep 2008 11:06:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmemcheck: lazy checking for MOVS instructions
Message-ID: <20080912090607.GA6632@elte.hu>
References: <20080911154616.GA16042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911154616.GA16042@localhost.localdomain>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Comments, anyone?
> 
> >From 36190b27a77b8ff5bbea09cf765c1f335c3920e4 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 11 Sep 2008 17:31:07 +0200
> Subject: [PATCH] kmemcheck: lazy checking for MOVS instructions
> 
> This patch adds the support for lazy (as opposed to eager) checking 
> for [REP] MOVS instructions (mostly used in memcpy()). This means that 
> if both the source and destination addresses are tracked by kmemcheck, 
> we copy the shadow memory instead of checking that it is initialized.
> 
> In this way, we get rid of a few more false positives.

looks good to me. I've applied it to tip/kmemcheck - but can zap it and 
pull your for-tip branch as well.

	Ingo
