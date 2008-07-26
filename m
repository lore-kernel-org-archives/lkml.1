Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYGZMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYGZMif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYGZMi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:38:27 -0400
Received: from toro.web-alm.net ([62.245.132.31]:46160 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYGZMi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:38:26 -0400
X-Greylist: delayed 5400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 08:38:26 EDT
Message-ID: <488B0474.1050205@osadl.org>
Date: Sat, 26 Jul 2008 13:03:16 +0200
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Sebastian Sewior <bigeasy@linutronix.de>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: 2.6.24.7-rt15
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

> We are pleased to announce the 2.6.24.7-rt15 tree [..]
Looks like this newest is also our greatest:

Board: Core 2 Duo, 2.4 GHz, Intel G965, 64 bit
Kernel: 2.6.24.7-rt15 prerelease
Config: CONFIG_IRQSOFF_TRACER, CONFIG_PREEMPT_TRACER, CONFIG_FTRACE
Stress: hackbench 25 loop, ls -Ral / loop, flood ping from outside
On-demand cpufreq disabled:
# cd /sys/devices/system/cpu
# echo performance >cpu0/cpufreq/scaling_governor
# echo performance >cpu1/cpufreq/scaling_governor
Test: cyclictest -a -t -n -p99 -i100 -d50
Result:
560.44 586.11 606.12 211/1160 3727
T: 0 (18617) P:99 I:100 C:1011846111 Min:  2 Act:  4 Avg:  5 Max: 39
T: 1 (18618) P:98 I:150 C: 708641019 Min:  2 Act:  5 Avg: 11 Max: 57

While running more than one billion cyclictest loops, the internal
worst-case latency did not exceed 39 microseconds.


Great work, thanks a lot!

	--cbe
