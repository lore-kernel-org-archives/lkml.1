Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbXFGKVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbXFGKVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXFGKVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:21:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbXFGKVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:21:30 -0400
Date: Thu, 7 Jun 2007 12:21:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org,
       jbaron@redhat.com, rostedt@goodmis.org, billh@gnuppy.monkey.org,
       linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
Message-ID: <20070607102123.GB12155@elte.hu>
References: <1181165656.7133.23.camel@dix> <1181204221.7348.238.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181204221.7348.238.camel@twins>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> we have around 1400 locks in the kernel, this would give 414400 per cpu.
> 
> vs the old code:
> 
> 2048*(4*8) = 65536
> +
> 2048*(4*4*8 + 4*8) = 327680 per cpu
> 
> worst case
> 
> I'm not convinced 300 lines less code is worth that extra bloat.

agreed, this is not worth it. It would be acceptable if the statistics 
stuff was flexible enough to have the same footprint as the current 
lockstat data structures.

	Ingo
