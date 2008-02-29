Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbYB2Tmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbYB2Tmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbYB2Tmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:42:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbYB2Tmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:42:31 -0500
Date: Fri, 29 Feb 2008 20:42:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@linux.vnet.ibm.com>
Subject: Re: A strange behavior of sched_fair
Message-ID: <20080229194213.GA21249@elte.hu>
References: <47C5E977.2010401@jp.fujitsu.com> <1204277686.6243.52.camel@lappy> <1204279909.6243.64.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204279909.6243.64.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Seems the vruntime doesn't get re-set if you move tasks between 
> > groups. sched_move_task() should call place_entity() in the context 
> > of the new cfs_rq.
> 
> This should do I guess - uncompiled, untested

if someone tests it and if it solves the problem i'll apply it to the 
scheduler tree.

	Ingo
