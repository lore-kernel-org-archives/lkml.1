Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYIFP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYIFP54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYIFP5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:57:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYIFP5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:57:46 -0400
Date: Sat, 6 Sep 2008 17:57:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat: generic compat get/settimeofday
Message-ID: <20080906155734.GA5061@elte.hu>
References: <20080901162231.GC16320@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901162231.GC16320@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0183]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> Nothing arch specific in get/settimeofday.  The details of the timeval
> conversion varied a little from arch to arch, but all with the same
> results.
> 
> Also add an extern declaration for sys_tz to linux/time.h because
> externs in .c files are fowned upon.  I'll kill the externs in various
> other files in a sparate patch.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

[ small nit: please include diffstats in future patches. ]

> Index: linux-2.6/arch/x86/ia32/ia32entry.S
> Index: linux-2.6/arch/x86/ia32/sys_ia32.c

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
