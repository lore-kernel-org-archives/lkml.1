Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbZDNJfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbZDNJfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZDNJfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:35:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbZDNJfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:35:21 -0400
Date: Tue, 14 Apr 2009 11:34:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, akpm@linux-foundation.org,
       dipankar@in.ibm.com, manfred@colorfullife.com, cl@linux-foundation.org,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH 0/3] v2 Make hierarchical RCU less IPI-happy and add
	more tracing
Message-ID: <20090414093441.GA3558@elte.hu>
References: <1239683478419-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239683478419-git-send-email->
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

> This three-patch set fixes a hierarchical-RCU performance bug 
> located by Anton Blanchard.  This bug affects certain high-end 
> floating-point computation-heavy workloads with closely spaced 
> barrier-synchronized iterations, where an interruption of any one 
> CPU's processing during a given iteration slows the system as a 
> whole.  This bug manifests itself as excessive resched IPIs, and 
> is strictly a performance regression. It does not affect 
> correctness.
> 
> The first patch provides the fix for the problem, the second patch 
> adds the tracing, and the third patch adds the documentation for 
> the tracing.
> 
> Located-by: Anton Blanchard <anton@au1.ibm.com>
> Tested-by: Anton Blanchard <anton@au1.ibm.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

i've applied the first patch to tip:core/urgent (for .30) and the 
second and third one to tip:core/rcu (for .31).

Thanks Paul,

	Ingo
