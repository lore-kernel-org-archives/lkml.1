Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbYGCMzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbYGCMzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYGCMzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:55:01 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:60817 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYGCMzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:55:00 -0400
X-Greylist: delayed 2320 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:55:00 EDT
Date: Thu, 3 Jul 2008 10:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask
	V3
Message-ID: <20080703084401.GB7873@elte.hu>
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org> <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com> <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com> <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com> <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48651EF5.5090808@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
> 
>   * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
>     node_to_cpumask and node_to_cpumask_ptr should be validated.
>     If invalid, then a dump_stack is performed and a zero cpumask
>     is returned.
> 
> Based on "Fri Jun 27 10:06:06 PDT 2008" tip/master...  ;-) 
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> V2: Slightly different version to remove a compiler warning.
> V3: Redone to reflect moving setup.c -> setup_percpu.c

applied to tip/x86/unify-setup - thanks Mike.

Vegard, can i add your Acked-by too?

	Ingo
