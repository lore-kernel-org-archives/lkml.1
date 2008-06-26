Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYFZN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYFZN4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbYFZN4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:56:24 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:10215 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbYFZN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:56:23 -0400
To: Linux Kernel <linux-kernel@vger.kernel.org>, svaidy@linux.vnet.ibm.com
Cc: Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
From: Andi Kleen <andi@firstfloor.org>
References: <20080625191100.GI21892@dirshya.in.ibm.com>
Date: Thu, 26 Jun 2008 15:49:01 +0200
In-Reply-To: <20080625191100.GI21892@dirshya.in.ibm.com> (Vaidyanathan Srinivasan's message of "Thu, 26 Jun 2008 00:41:00 +0530")
Message-ID: <87k5gcqpbm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jun 2008 13:41:44.0016 (UTC) FILETIME=[5F104D00:01C8D792]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> writes:
>
> The idea being proposed is to enhance the tunable with varied degrees
> of consolidation that can work best for different workload
> characteristics.  echo 2 > /sys/.../sched_mc_power_savings could
> enable more aggressive consolidation than the default.

It would be better to fix the single power saving default to work
better with bursty workloads too than to add more tunables. Tunables
are basically "we give up, let's push the problem to the user"
which is not nice. I suspect a lot of users won't even know if their
workloads are bursty or not.  Or they might have workloads which
are both bursty and not bursty.

Or did you try that and failed?

-Andi
