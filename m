Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYHULlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYHULlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbYHULls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:41:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbYHULlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:41:47 -0400
Date: Thu, 21 Aug 2008 13:41:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
Message-ID: <20080821114126.GB30667@elte.hu>
References: <1219310330.8651.93.camel@twins> <48AD534A.9080807@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD534A.9080807@novell.com>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> I haven't had a chance to review the code thoroughly yet, but I had 
> been working on a similar fix and know that this is sorely needed.  
> So...

btw., why exactly does this patch speed up certain workloads? I'm not 
quite sure about the exact reasons of that.

	Ingo
