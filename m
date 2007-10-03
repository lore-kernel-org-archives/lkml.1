Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbXJCHVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbXJCHVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXJCHVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:21:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXJCHVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:21:03 -0400
Date: Wed, 3 Oct 2007 09:20:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: nickpiggin@yahoo.com.au, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Message-ID: <20071003072051.GD2619@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200709301335.00441.nickpiggin@yahoo.com.au> <20071001111528.5487b4f4.pj@sgi.com> <200710022335.05357.nickpiggin@yahoo.com.au> <20071003062240.GA19027@elte.hu> <20071002235615.6e8cd007.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002235615.6e8cd007.pj@sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> Batch schedulers need to be able to specify where they need load 
> balancing and where they don't, and they can't use the 'cpu_exclusive' 
> flag.  The defining characteristic of 'cpu_exclusive' is no overlap of 
> CPUs with sibling cpusets.  That is incompatible with their needs.
> 
> Therefore, they need a different flag.
> 
> I must NAQ this patch, and I'm surprised to see Nick propose it again, 
> as I thought he had already agreed that it didn't suffice.

ok. Then lets go back to the original plan: your two patches and the new 
flag. Nick?

	Ingo
