Return-Path: <linux-kernel-owner+w=401wt.eu-S966283AbXEGTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966283AbXEGTFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966234AbXEGTE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:04:58 -0400
Received: from mail-blu.bigfish.com ([65.55.251.10]:64316 "EHLO
	mail130-blu-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966223AbXEGTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:04:57 -0400
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 15:04:57 EDT
X-BigFish: VP
Message-ID: <463F7449.2020509@am.sony.com>
Date: Mon, 07 May 2007 11:47:37 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Need help debugging RT-preempt patch
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2007 18:44:30.0986 (UTC) FILETIME=[BF93EEA0:01C790D7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've applied patch-2.6.21-rt1 to a 2.6.21 kernel I'm using.
With the patch applied, but no RT-Preempt options enabled,
I'm getting network failures (eth0 transmit timeouts) on
an OMAP board.

I'm not sure what the best method is to debug this.  Should
I turn on the latency tracer?  Should I post my configuration?
Should I try to break up the patch and apply changes in small doses?
I'm not familiar with the network code, or with the RT code (yet),
so for now I'm kind of stumbling in the dark.

Note that I have other patches applied, for platform support
for the OMAP.

I believe ARM (or OMAP) is not supported by the RT-preempt patch
at the moment.  But I'd like to carry the patches in my kernel even
if the options for RT-preempt are off, because I want to experiment
with RT-preempt on other platforms (x86 and MIPS).

Any suggestions for where to start to isolate this would
be appreciated.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Electronics
=============================

