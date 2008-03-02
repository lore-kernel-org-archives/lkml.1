Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYCBT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYCBT6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYCBT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:58:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33920 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYCBT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:58:09 -0500
Date: Sun, 2 Mar 2008 11:57:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       suresh.b.siddha@intel.com, Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Too many timer interrupts in NO_HZ
Message-ID: <20080302115709.30403490@laptopd505.fenrus.org>
In-Reply-To: <20080302194812.GD10028@dirshya.in.ibm.com>
References: <20080302194812.GD10028@dirshya.in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 01:18:13 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> Hi,
> 
> I am trying to play around with the tickless kernel and
> sched_mc_power_savings tunables to increase the idle duration of the
> CPU in an SMP server.  sched_mc_power_savings provides good
> consolidation of long running jobs when the system is lightly loaded.
> However I am interested to see CPU idle times for couple minutes on
> atleast few CPUs in an completely idle SMP system.
> 
> I have posted related instrumentation results at
> http://lkml.org/lkml/2008/1/8/243
> 
> The experimental setup is identical.  Just that I have tried to
> collect more data and also bias the wakeup logic.
> 
> The kernel is 2.6.25-rc3 with NO_HZ, SCHED_MC, HIGH_RES_TIMERS, and
> HPET turned on.
> 
> I have tried to collect interesting data from tick-sched.c, sched.c
> and softirq.c.
> 
> As suggested by Ingo in the previous thread, I have hacked the sched.c
> try_to_wake_up logic so that I can force all wake-ups to happen on
> CPU0.  This is just and experiment, in reality we will have to
> carefully choose a domain and CPU to bias all wakeups on an idle
> system.


please show us powertop -d output; that way we can at least see sort of what
is going on...
