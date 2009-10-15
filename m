Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbZJOLVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbZJOLVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762694AbZJOLVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:21:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427AbZJOLVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:21:38 -0400
Date: Thu, 15 Oct 2009 13:20:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, jens.axboe@oracle.com
Subject: Re: [PATCH tip/core/rcu 2/6] rcu: prevent RCU IPI storms in
	presence of high call_rcu() load
Message-ID: <20091015112015.GB29080@elte.hu>
References: <20091014171517.GA13635@linux.vnet.ibm.com> <20091015110404.GC3127@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015110404.GC3127@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> Testing this on top of my vfs-scale patches, a 64-way 32-node ia64 
> system runs the parallel open/close microbenchmark ~30 times faster 
> and is scaling linearly now. Single thread performance is not 
> noticably changed. Thanks very much Paul.

Cool, thanks for the testing Nick!

	Ingo
