Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbYLCIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbYLCIku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYLCIkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:40:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35202 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYLCIkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:40:40 -0500
Date: Wed, 3 Dec 2008 09:40:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de
Subject: Re: [PATCH -tip] v9 scalable classic RCU implementation
Message-ID: <20081203084013.GB5668@elte.hu>
References: <20081202222157.GA14911@linux.vnet.ibm.com> <20081202233144.GE6703@one.firstfloor.org> <20081202235145.GF6719@linux.vnet.ibm.com> <20081203001811.GF6703@one.firstfloor.org> <20081203004759.GG6719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203004759.GG6719@linux.vnet.ibm.com>
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

> I am currently undergoing a line-by-line code walkthrough of rcutree on 
> the off-chance that all three versions of RCU suffer from the same bug. 
> (And I have found a few bugs and spelling errors, but nothing related 
> to the problem at hand.)  If I don't find anything, I will start 
> looking more closely at the CPU-hotplug code.

yep, CPU-hotplug is where i'd suspect problems, as it has changed 
recently.

	Ingo
