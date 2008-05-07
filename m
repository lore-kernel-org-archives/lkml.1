Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbYEGGnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbYEGGnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYEGGnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:43:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37364 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbYEGGnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:43:43 -0400
Date: Wed, 7 May 2008 08:43:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, peterz@infradead.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: Soft lockup regression from today's sched.git merge.
Message-ID: <20080507064320.GC32195@elte.hu>
References: <20080422.030519.259068348.davem@davemloft.net> <1208868304.7115.251.camel@twins> <200805070041.02618.rjw@sisk.pl> <20080506.160508.58694844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506.160508.58694844.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Wed, 7 May 2008 00:41:01 +0200
> 
> > Can you please tell me what the current status of this is?
> 
> Group scheduling bug, fixed in Linus's tree already.

fixed by:

 commit 3f5087a2bae5d1ce10a3d698dec8f879a96f5419
 Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 Date:   Fri Apr 25 00:25:08 2008 +0200

     sched: fix share (re)distribution

     fix __aggregate_redistribute_shares() related lockup reported by
     David S. Miller.
 [...]

	Ingo
