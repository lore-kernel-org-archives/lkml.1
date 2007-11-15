Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbXKOXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbXKOXaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbXKOXao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:30:44 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:64997 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755451AbXKOXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:30:43 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <473CD6E1.1060607@am.sony.com>
Date: Thu, 15 Nov 2007 15:31:45 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: john cooper <john.cooper@third-harmonic.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: MIPS RT debug support
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain> <473BADD4.5030400@third-harmonic.com>
In-Reply-To: <473BADD4.5030400@third-harmonic.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2007 23:30:35.0302 (UTC) FILETIME=[859EB460:01C827DF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john cooper wrote:
> The more daunting problem stems from limitations in the MIPS
> ABI which makes the latency trace support problematic.
> Rather than rehash the issue:
> 
>     http://lists.linuxcoding.com/kernel/2005-q4/msg10163.html
> 
> Until we have a usable instrumentation solution in place,
> characterization, debug, and support of PREEMPT_RT for MIPS
> is going to be a challenge.

Agreed.  I have been using KFT (Kernel Function Trace)
on MIPS, and it has decent support for function traceback
reporting, but it's not currently integrated with latency-trace
at all.   We should discuss if this could possibly be
used to debug RT-preempt.  It is much heavier weight than
the mcount stuff, but uses similar (but not identical)
gcc profiling instrumentation.  I'm not sure if the
two can be turned on together, or how hard it would
be to move latency-trace onto -finstrument_functions.

But it's probably worth researching a little.  We'll
need something to give insight into the problem paths.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

