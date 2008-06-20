Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYFTKh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYFTKh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 06:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYFTKhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 06:37:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYFTKhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 06:37:19 -0400
Date: Fri, 20 Jun 2008 12:37:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: add lock_class information to lock_chain and
	output it
Message-ID: <20080620103704.GA717@elte.hu>
References: <1213951161.29952.5.camel@caritas-dev.intel.com> <20080620101943.GA32500@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620101943.GA32500@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0151]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, the patch has some build problems:

 kernel/built-in.o: In function `lc_next':
 lockdep_proc.c:(.text+0x31c83): undefined reference to `nr_lock_chains'
 lockdep_proc.c:(.text+0x31cb1): undefined reference to `lock_chains'
 kernel/built-in.o: In function `lc_start':
 lockdep_proc.c:(.text+0x31cf4): undefined reference to `nr_lock_chains'
 lockdep_proc.c:(.text+0x31d08): undefined reference to `lock_chains'
 kernel/built-in.o: In function `lockdep_chains_open':
 lockdep_proc.c:(.text+0x31e59): undefined reference to `nr_lock_chains'

with this config:

  http://redhat.com/~mingo/misc/config-Fri_Jun_20_12_29_35_CEST_2008.bad

	Ingo
