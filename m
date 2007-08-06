Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbXHFHdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbXHFHdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbXHFHdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:33:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXHFHdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:33:23 -0400
Date: Mon, 6 Aug 2007 09:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: josh@kernel.org, josht@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] CFS: Mark print_cfs_stats static
Message-ID: <20070806073258.GK5359@elte.hu>
References: <1184957097.2630.17.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184957097.2630.17.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@kernel.org> wrote:

> sched_fair.c defines print_cfs_stats, and sched_debug.c uses it, but 
> sched.c includes both sched_fair.c and sched_debug.c, so all the 
> references to print_cfs_stats occur in the same compilation unit.  
> Thus, mark print_cfs_stats static.
> 
> Eliminates a sparse warning: warning: symbol 'print_cfs_stats' was not 
> declared. Should it be static?

thanks, applied.

	Ingo
