Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbZFPGYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbZFPGYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFPGYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:24:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbZFPGYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:24:08 -0400
Date: Mon, 15 Jun 2009 23:23:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
Message-Id: <20090615232318.74b099a6.akpm@linux-foundation.org>
In-Reply-To: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:

> Currently on a ppc64 box with 16 CPUs, the time taken for
> a individual cpu-hotplug operation is as follows.
> 
> 	# time echo 0 > /sys/devices/system/cpu/cpu2/online
> 	real    0m0.025s
> 	user    0m0.000s
> 	sys     0m0.002s
> 
> 	# time echo 1 > /sys/devices/system/cpu/cpu2/online
> 	real    0m0.021s
> 	user    0m0.000s
> 	sys     0m0.000s

Surprised.  Do people really online and offline CPUs frequently enough
for this to be a problem?

