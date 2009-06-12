Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZFLFvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZFLFvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 01:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZFLFvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 01:51:11 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:60672 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZFLFvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 01:51:10 -0400
Message-ID: <4A31ECCD.7030805@in.ibm.com>
Date: Fri, 12 Jun 2009 11:21:09 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PowerPC] 2.6.30-git3 build break : perf counters
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-git3 build with CONFIG_PERF_COUNTERS=y failed on a powerpc box.

 CC      arch/powerpc/kernel/power7-pmu.o
arch/powerpc/kernel/power7-pmu.c:297: error: PERF_COUNT_CPU_CYCLES undeclared here (not in a function)
arch/powerpc/kernel/power7-pmu.c:297: error: array index in initializer not of integer type
arch/powerpc/kernel/power7-pmu.c:297: error: (near initialization for power7_generic_events)
arch/powerpc/kernel/power7-pmu.c:298: error: PERF_COUNT_INSTRUCTIONS undeclared here (not in a function)
arch/powerpc/kernel/power7-pmu.c:298: error: array index in initializer not of integer type
......<SNIP>......

Porbably because of commit 526e9a09d2e2dcb6c75c68710465678bb647e5fe

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

