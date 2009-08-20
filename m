Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZHTG3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZHTG3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 02:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZHTG3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 02:29:42 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47884 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbZHTG3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 02:29:41 -0400
Date: Thu, 20 Aug 2009 16:24:51 +1000
From: Anton Blanchard <anton@samba.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, balbir@linux.vnet.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090820062451.GH21100@kryten>
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090716081010.GB3134@in.ibm.com> <20090716083948.GA2950@kryten> <20090820051038.GF21100@kryten> <20090820052605.GC26265@balbir.in.ibm.com> <1250747579.8282.110.camel@twins> <20090820060528.GG21100@kryten> <20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> Could you share contex-switch-test program ?
> I'd like to play with it to find out what I can do against percpu counter.

Sure:

http://ozlabs.org/~anton/junkcode/context_switch.c

Very simple, just run it once per core:

for i in `seq 0 31`
do
	taskset -c $i ./context_switch &
done

Then look at the context switch rates in vmstat.

Anton
