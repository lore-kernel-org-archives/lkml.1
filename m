Return-Path: <linux-kernel-owner+w=401wt.eu-S1765010AbYDPOAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765010AbYDPOAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763128AbYDPOAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:00:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42165 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYDPOAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:00:33 -0400
Date: Wed, 16 Apr 2008 16:00:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [RFC] Verification and debugging of memory
	initialisation
Message-ID: <20080416140018.GB24383@elte.hu>
References: <20080416135058.1346.65546.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416135058.1346.65546.sendpatchset@skynet.skynet.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> Boot initialisation has always been a bit of a mess with a number of 
> ugly points. While significant amounts of the initialisation is 
> architecture-independent, it trusts of the data received from the 
> architecture layer. This was a mistake in retrospect as it has 
> resulted in a number of difficult-to-diagnose bugs.
> 
> This patchset is an RFC to add some validation and tracing to memory 
> initialisation. It also introduces a few basic defencive measures and 
> depending on a boot parameter, will perform additional tests for 
> errors "that should never occur". I think this would have reduced 
> debugging time for some boot-related problems. The last part of the 
> patchset is a similar fix for the patch "[patch] mm: sparsemem 
> memory_present() memory corruption" that corrects a few more areas 
> where similar errors were made.
> 
> I'm not looking to merge this as-is obviously but are there opinions 
> on whether this is a good idea in principal? Should it be done 
> differently or not at all?

very nice stuff!

  Acked-by: Ingo Molnar <mingo@elte.hu>

or rather:

  Very-Strongly-Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
