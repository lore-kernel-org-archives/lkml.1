Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbZFQTV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbZFQTV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZFQTVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:21:50 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37805 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbZFQTVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:21:49 -0400
Date: Thu, 18 Jun 2009 00:51:16 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: venkatesh.pallipadi@intel.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/2] RFC sched: Scale the nohz_tracker logic by making
	it per NUMA node
Message-ID: <20090617192116.GI7961@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090617182649.604970000@intel.com> <20090617182741.107659000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090617182741.107659000@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> [2009-06-17 11:26:51]:

> Having one idle CPU doing the rebalancing for all the idle CPUs in
> nohz mode does not scale well with increasing number of cores and
> sockets. Make the nohz_tracker per NUMA node. This results in multiple
> idle load balancing happening at NUMA node level and idle load balancer
> only does the rebalance domain among all the other nohz CPUs in that
> NUMA node.

This is a good optimisations but maybe an overkill for single chip
NUMA node machines like a two socket Nehalems or Optrons.

Some method to create load balancer group based on the scale of the
machine will be good.

--Vaidy
