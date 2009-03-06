Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZCFUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZCFUop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZCFUoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:44:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37423 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZCFUog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:44:36 -0500
Message-ID: <49B18B2E.606@us.ibm.com>
Date: Fri, 06 Mar 2009 12:44:30 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "lkml, " <linux-kernel@vger.kernel.org>
Subject: Dynamically determine if kernel includes CFS Scheduler
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've received an internal request for a means to determine at run-time 
if the CFS scheduler is included in the running kernel.  Looking through 
the git commit log and the /proc/sys/kernel filesystem, I think I see 
two approaches:

1) stat("/proc/sys/kernel/sched_compat_yield")
    This confirms 2.6.23-rc7 kernel or later which definitely has the CFS
    scheduler and this functionality is of interest anyway.
2) Test if the kernel version is >= 2.6.22 which is where I believe CFS
    landed.

Any guesses as to how robust/future-proof approach #1 would be?

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
