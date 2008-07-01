Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYGAGF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYGAGF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYGAGFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:05:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYGAGFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:05:48 -0400
Date: Tue, 1 Jul 2008 07:59:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, Franck Bui-Huu <fbuihuu@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Triplett <josh@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] Introduce rculist.h
Message-ID: <20080701055903.GC14658@elte.hu>
References: <20080701125607.c5295759.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701125607.c5295759.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> In linux-next there is a commit ("rcu: split list.h and move 
> rcu-protected lists into rculist.h") that moved the rcu related list 
> iterators from list.h to rculist.h.  Add a trivial version of the file 
> now so that various subsystem trees can start using it now for -next 
> changes and so reduce the build errors caused by adding uses of the 
> moved functions.
> 
> Cc: Franck Bui-Huu <fbuihuu@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
