Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYCUMEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYCUMEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYCUMEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:04:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYCUMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:04:14 -0400
Date: Fri, 21 Mar 2008 13:04:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: allcate e820 resource struct all together
Message-ID: <20080321120404.GE25225@elte.hu>
References: <200803202357.22045.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803202357.22045.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> don't need to allocate that one by one

> +	struct resource *res;
> +	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);

nice one - applied.

(minor style nit: please keep a newline between variable definitions and 
the first line of code, to make it a bit more readable.)

	Ingo
