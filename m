Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYAIMWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYAIMWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYAIMWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:22:42 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:53660 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753336AbYAIMWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:22:41 -0500
Date: Wed, 9 Jan 2008 17:58:47 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, Arjan van de Ven <arjan@infradead.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Analysis of sched_mc_power_savings
Message-ID: <20080109122847.GA28955@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	discuss@LessWatts.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, venkatesh.pallipadi@intel.com,
	tglx@linutronix.de, Arjan van de Ven <arjan@infradead.org>,
	Gautham R Shenoy <ego@in.ibm.com>,
	Chanda Sethia <chanda.sethia@in.ibm.com>
References: <20080108173815.GA7793@dirshya.in.ibm.com> <20080108212400.GA8903@linux-os.sc.intel.com> <20080109111302.GC7793@dirshya.in.ibm.com> <20080109113507.GA29721@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080109113507.GA29721@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-01-09 12:35:07]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > How do we take this technique to the next step where we can 
> > consolidate short running jobs as well?  Did you face any difficulty 
> > biasing the CPU for short running jobs?
> 
> are you sure your measurement tasks do not impact the measurement 
> workload? If you use something like 'top' then try running it reniced to 
> +19. (or perhaps even bound to a particular CPU, say #3, to make its 
> impact isolated)

Hi Ingo,

I will watch this during the experiments.  I have been using klog
application to dump relayfs data.  I did run powertop and top as well,
I will bind them to certain CPUs and isolate their impact.

I believe the margin of error would be less since all the measurement
tasks sleep for long duration.

Thanks,
Vaidy

