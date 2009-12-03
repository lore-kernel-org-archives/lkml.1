Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZLCDw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZLCDw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZLCDwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:52:25 -0500
Received: from nskntqsrv01p.mx.bigpond.com ([61.9.168.231]:29832 "EHLO
	nskntqsrv01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbZLCDwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:52:24 -0500
X-Greylist: delayed 8816 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 22:52:24 EST
Message-ID: <4B17138D.3040003@bigpond.net.au>
Date: Thu, 03 Dec 2009 11:25:33 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch]  f83f9ac causes tasks running at MAX_PRIO
References: <1259501027.6268.9.camel@marge.simson.net>	 <1259754383.4003.610.camel@laptop> <1259758150.6167.8.camel@marge.simson.net>
In-Reply-To: <1259758150.6167.8.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx02p.mx.bigpond.com from [123.211.185.123] using ID pwil3058@bigpond.net.au at Thu, 3 Dec 2009 01:25:33 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150201.4B17138E.002C,ss=1,fgs=0
X-SIH-MSG-ID: qRw0Ftb8TECznTh522DtQVUtlUy7/yU1v8pWRYIhuRsaT1jBuMDAQsKmbaJDwp6CjHtcQk/WLnEjc6zlV43UuNq0Mb5RWrnj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/09 22:49, Mike Galbraith wrote:
> Hysterical reasons?  That might have been a doorstop conversion kit for
> O(1), but boots fine with CFS, and prio 40 tasks are history.

In my (not so) humble opinion, there is still a lot of unnecessary cruft 
in sched.c that should have been removed as the final (clean up) stage 
of implementing CFS (i.e. stuff that was needed for O(1) but no longer 
serves a useful purpose).  I know that the extra overhead of this code 
is probably inconsequential (and the compiler may even optimize some of 
it away) but it looks untidy and makes the code harder to understand.

Recent patches that I've submitted were intended as a start to removing 
some of this cruft and I had intended to send more patches after they 
were accepted.  I figured that it was better to do it as a number of 
small changes rather than one big one.  Should I continue?

Peter
