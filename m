Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbZKPKgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbZKPKgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZKPKgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:36:53 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45717 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZKPKgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:36:52 -0500
Date: Mon, 16 Nov 2009 16:06:49 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [v9 PATCH 0/9]: cpuidle: Cleanup cpuidle/ Introduce cpuidle to
 POWER.
Message-ID: <20091116103649.GA23142@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091016093850.GB27350@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091016093850.GB27350@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-16 15:08:50]:

> Hi,
> 
> This patchset introduces cpuidle infrastructure to POWER, prototyping
> for pSeries, and also does a major refactoring of current x86 idle
> power management and a cleanup of cpuidle infrastructure.
> 
> This patch series has been in discussion for quite a while now and
> below are the links to the previous discussions.
> 
> Hopefully, this is ready to be included in the -tip tree.
> 
> v8 --> http://lkml.org/lkml/2009/10/8/82
> v7 --> http://lkml.org/lkml/2009/10/6/278
> v6 --> http://lkml.org/lkml/2009/9/22/180
> v5 --> http://lkml.org/lkml/2009/9/22/26
> v4 --> http://lkml.org/lkml/2009/9/1/133
> v3 --> http://lkml.org/lkml/2009/8/27/124
> v2 --> http://lkml.org/lkml/2009/8/26/233
> v1 --> http://lkml.org/lkml/2009/8/19/150
> 
> 
> Changes in this version:
> ----------------------------------------
>         *Added documentation for the new design regarding registration
>         of idle routines in Documentation/cpuidle/core.txt
> 
>         *Platforms which do not want the code bloat of cpuidle can
>         disable CONFIG_CPU_IDLE. Alternate definition of
>         cpuidle_idle_call is provided which would call the appropriate
>         idle routine provided by the arch without the overhead of
>         registration and governors.
>         (Thanks to Andi for raising this isuue)
> 
>         *I had missed a cpuidle_kick_cpus() in
>         cpuidle_pause_and_lock() which is called from the hotplug
>         path. So added that and tested this patchset by subjecting it
>         to cpuhotplug torture.
>         (Thanks to Balbir for noticing this)
> 
> 

Hi Peter,

Did you get time to look at this series?
Please let me know if we need any changes to this version to get it
merged.

thanks
> --arun
> 
