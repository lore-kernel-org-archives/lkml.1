Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXKOCdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXKOCdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 21:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXKOCdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 21:33:14 -0500
Received: from dpc691978010.direcpc.com ([69.19.78.10]:56813 "EHLO
	third-harmonic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXKOCdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 21:33:13 -0500
X-Greylist: delayed 710 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 21:33:09 EST
Message-ID: <473BADD4.5030400@third-harmonic.com>
Date: Wed, 14 Nov 2007 21:24:20 -0500
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: rt-preempt: problem compiling rt-preempt 2.6.23.1-rt11 on MIPS
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> I fear you are the one who is in charge to get mips working again :)
> But as always, there are bad news and good news:  As far as I heard
> last week John Cooper is looking into this as well.

I'm not actively working on it but AFAIK I may have been
the last one to touch it when I did the mips version back
at Timesys.  Although I was able to get a functional port
of the work there were gremlins I never had sufficient
time to address.  That is a relatively minor issue.

The more daunting problem stems from limitations in the MIPS
ABI which makes the latency trace support problematic.
Rather than rehash the issue:

     http://lists.linuxcoding.com/kernel/2005-q4/msg10163.html

Until we have a usable instrumentation solution in place,
characterization, debug, and support of PREEMPT_RT for MIPS
is going to be a challenge.

-john

-- 
john.cooper@third-harmonic.com
