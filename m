Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbZELKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbZELKNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZELKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:13:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45504 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZELKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:13:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090512101057.GD6351@balbir.in.ibm.com>
References: <20090512185836.D635.A69D9226@jp.fujitsu.com> <20090512101057.GD6351@balbir.in.ibm.com>
Message-Id: <20090512191206.D63B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 19:13:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifdef CONFIGCONFIG_SMP
> > +	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > +#endif
> 
> Slow down and compile patches before sending them out.. please. That
> is a basic expectation if you expect it to be merged.

Unfortunately, this mistake pass test successfully ;)
it because cpuacct_batch=0 works even SMP.



