Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbXJCMOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbXJCMOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbXJCMOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:14:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50936 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755820AbXJCMOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:14:43 -0400
Date: Wed, 3 Oct 2007 05:14:38 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003051438.e1371e99.pj@sgi.com>
In-Reply-To: <200710030525.29735.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030356.18090.nickpiggin@yahoo.com.au>
	<20071003043818.baa0e1ce.pj@sgi.com>
	<200710030525.29735.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> These are what I'm worried about, and things like kswapd, pdflush,
> could definitely use a huge amount of CPU.
> 
> If you are interested in hard partitioning the system, you most
> definitely want these things to be balanced across the non-isolated
> CPUs.

But these guys are pinned anyway (or else they would already be moved
into a smaller load balanced cpuset), so why waste time load balancing
what can't move?

And on some of the systems I care about, we don't want to load balance
these guys; rather we go to great lengths to see that they don't run at
all when we don't want them to.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
