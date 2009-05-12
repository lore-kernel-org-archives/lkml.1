Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZELKY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZELKY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZELKYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:24:16 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40969 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZELKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:24:15 -0400
Date: Tue, 12 May 2009 15:54:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090512102412.GG6351@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090512185836.D635.A69D9226@jp.fujitsu.com> <20090512101057.GD6351@balbir.in.ibm.com> <20090512191206.D63B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090512191206.D63B.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-05-12 19:13:42]:

> > > +#ifdef CONFIGCONFIG_SMP
> > > +	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > > +#endif
> > 
> > Slow down and compile patches before sending them out.. please. That
> > is a basic expectation if you expect it to be merged.
> 
> Unfortunately, this mistake pass test successfully ;)
> it because cpuacct_batch=0 works even SMP.
>

OK, BTW, using an #ifdef right in the middle of a function makes the
code harder to read, can't we use an inline function to abstract out
SMP? 

-- 
	Balbir
