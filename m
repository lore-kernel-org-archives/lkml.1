Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYLOHES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYLOHES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 02:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYLOHED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 02:04:03 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:58859 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYLOHEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 02:04:01 -0500
Date: Mon, 15 Dec 2008 12:32:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 7/7] sched: idle_balance() does not call
	load_balance_newidle()
Message-ID: <20081215070237.GF18403@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com> <20081211174323.2020.97965.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081211174323.2020.97965.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-11 23:13:23]:

> load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE
> is set at higher level domain (3-CPU) and not in low level domain
> (2-MC).
> 
> pulled_task is initialised to -1 and checked for non-zero which
> is always true if the lowest level sched_domain does not have
> SD_BALANCE_NEWIDLE flag set.
> 
> Trivial fix to initialise pulled_task to zero.
>

This is already pulled in for 2.6.29, so I am not reviewing it. We can
drop it from the next patch series. 

-- 
	Balbir
