Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYHOPLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYHOPLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYHOPLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:11:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56176 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbYHOPLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:11:24 -0400
Date: Fri, 15 Aug 2008 16:56:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@tv-sign.ru,
       manfred@colorfullife.com, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080815145632.GA9664@elte.hu>
References: <20080805162144.GA8297@linux.vnet.ibm.com> <20080815140902.GE14103@elte.hu> <20080815142430.GA20722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815142430.GA20722@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> my guess is on:
> 
>  commit 1f7b94cd3d564901f9e04a8bc5832ae7bfd690a0
>  Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>  Date:   Tue Aug 5 09:21:44 2008 -0700
> 
>     rcu: classic RCU locking and memory-barrier cleanups

yep, reverting that one made the lockdep warning go away. (note, i still 
kept the commit in tip/core/rcu so a delta fix against the previous 
patch would be preferred)

	Ingo
