Return-Path: <linux-kernel-owner+w=401wt.eu-S1764359AbXLMREZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764359AbXLMREZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbXLMREN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:04:13 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57871 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbXLMREM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:04:12 -0500
Date: Thu, 13 Dec 2007 22:33:49 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E McKenney <paulmck@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 0/6] RCU: Preemptible-RCU
Message-ID: <20071213170348.GA25981@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone, 

This patchset is an updated version of the preemptible RCU patchset that
Paul McKenney had posted it in September earlier this year that can be
found here --> http://lkml.org/lkml/2007/9/10/213

This patchset incorporates the review comments from Oleg Nesterov
and Steven Rostedt.

The testing report of the patchset is as follows:
====================================================================
Patch-stack:  	2.6.23-rc3 + cpu-hotplug patches from 
		http://lkml.org/lkml/2007/11/15/239 + Preempt-RCU
		patches.
Test:		RCU-Torture running parallelly with CPU-Hotplug
		operations.
Duration:	24 hours.
Architectures:	x86,x86_64, ppc64.
====================================================================


Currently it is based against the latest linux-2.6-sched-devel.git

Awaiting your feedback!

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
