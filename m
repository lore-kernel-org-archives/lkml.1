Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYG3BS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYG3BS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYG3BSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:18:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:35677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYG3BSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:18:16 -0400
Message-ID: <488FC0AB.8010805@kernel.org>
Date: Wed, 30 Jul 2008 10:15:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] RCU: implement rcu_read_[un]lock_preempt()
References: <487AEAC6.60307@kernel.org> <1216188469.5232.0.camel@twins>	 <487D98AC.3020005@kernel.org> <1217258001.18049.7.camel@twins>	 <488E76A2.9050804@kernel.org> <1217312129.18049.44.camel@twins>
In-Reply-To: <1217312129.18049.44.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 30 Jul 2008 01:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Therefore we prefer APIs such as, get_cpu() etc.. that show intent and
> don;t like stuff you just now proposed of mixing intents. Because when
> changing the preemption model you might need different solution for
> different intents.

Alright, will convert to get_cpu().  Thanks for the explanation.

-- 
tejun
