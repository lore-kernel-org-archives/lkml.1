Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYBERQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYBERQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYBERQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:16:07 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:55091 "EHLO
	outbound7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbYBERQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:16:06 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47A898DD.9020803@am.sony.com>
Date: Tue, 05 Feb 2008 09:11:57 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 00/23 -v8] mcount and latency tracing utility -v8
References: <20080130210357.927754294@goodmis.org>
In-Reply-To: <20080130210357.927754294@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 17:15:43.0426 (UTC) FILETIME=[BD4A4A20:01C8681A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> [
>   version 8 of mcount / trace patches:

I applied these to 2.6.24, making a few fixups to do so.
If you haven't already done this, I can send them to you.

Here is the list of stuff I found.

mcount-add-basic-support-for-gcc-profiler-instrum.patch:
   fix for changes in patch context in lib/Kconfig.debug

mcount-trace-latency-trace-preempt-off.patch:
   fix for missing #include hrtimer.h in kernel/sched.c

tracer-add-event-markers.patch:Changelog:
   Had to adjust patch for change in kernel/hrtimer.c:hrtimer_interrupt()
   I'm not sure if I did this right.

Thanks for the patch set.  I plan to give it a test today.
  -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

