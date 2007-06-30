Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXF3TYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXF3TYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXF3TYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:24:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXF3TYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:24:16 -0400
Date: Sat, 30 Jun 2007 21:24:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.21.5-rt17 on lenovo t61, some BUG's (lukewarm IQ?)
Message-ID: <20070630192403.GE3720@elte.hu>
References: <1183000802.4085.5.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183000802.4085.5.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> Hi Ingo, this is happening in a brand new laptop, a Lenovo t61 with a 
> 7700 processor and the Santa Rosa chipset.
> 
> Lukewarm IQ detected in hotplug locking
> BUG: at kernel/cpu.c:44 lock_cpu_hotplug()

hm, that's an upstream kernel message. Cpu-hotplug locking is ... a bit 
messy still. Does it otherwise work? (it should only affect sw-suspend 
on SMP)

> [BTW, I tried to unsuccessfully boot rt18 today in one of my CCRMA 
> machines but the boot hung when trying to start the acpi daemon - this 
> was on FC6, I'll try to find out more tomorrow. We are seeing some 
> hungs with rt17 that I have not tried to diagnose yet]

do you still see this?

	Ingo
