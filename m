Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbYHRHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbYHRHqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYHRHqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:46:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYHRHqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:46:08 -0400
Date: Mon, 18 Aug 2008 09:45:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/cor/rcu] remove redundant ACCESS_ONCE definition
	from rcupreempt.c
Message-ID: <20080818074538.GE30694@elte.hu>
References: <20080817195036.GA27585@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817195036.GA27585@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Remove the redundant definition of ACCESS_ONCE() from rcupreempt.c in 
> favor of the one in compiler.h.  Also merge the comment header from 
> rcupreempt.c's definition into that in compiler.h.

applied to tip/core/rcu, thanks Paul!

	Ingo
