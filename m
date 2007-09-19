Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbXISXUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbXISXUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXISXUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:20:40 -0400
Received: from mail1.opticatech.com ([63.253.105.122]:21125 "EHLO
	opticatech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754601AbXISXUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:20:39 -0400
Message-ID: <46F1AEBB.6000809@comcast.net>
Date: Wed, 19 Sep 2007 17:20:27 -0600
From: Chris Rigg <cdrigg@comcast.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: MAX_RT_PRIO - 1 Highest prio?
References: <46EEE498.1080500@comcast.net> <20070918050043.GE10199@1wt.eu> <20070918062606.GA5138@elte.hu>
In-Reply-To: <20070918062606.GA5138@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 23:20:35.0360 (UTC) FILETIME=[AE7B1200:01C7FB13]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First, I'm assuming that if I want my task to have the HIGHEST priority 
in the system (i.e. preempt any other task whenever it is put into the 
ready queue (assuming I have preemption turned on/configured)), I use 
sched_setscheduler (...) and use the sched_priority in sched_param for 
MAX_RT_PRIO -1. Is this correct?

Second, assuming that MAX_RT_PRIO-1 is the highest, would it be bad on 
an SMP/Hyperthreading system (that's using the migration thread 
balancing in 2.6.20.7) to set a task's priority to MAX_RT_PRIO -1 given 
the fact that the migration threads are already set to MAX_RT_PRIO -1? 
Should I be setting my task's prio to MAX_RT_PRIO-2 to not interfere 
with the load balancing?

Thanks,
Chris

