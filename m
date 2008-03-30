Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYC3UAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYC3UAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYC3UAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:00:34 -0400
Received: from www.tglx.de ([62.245.132.106]:41754 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYC3UAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:00:33 -0400
Date: Sun, 30 Mar 2008 21:59:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Chr <chunkeey@web.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with
 2.6.25-rc7
In-Reply-To: <200803302125.10817.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0803302156210.3219@apollo.tec.linutronix.de>
References: <200803302109.22219.chunkeey@web.de> <200803302125.10817.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Rafael J. Wysocki wrote:
> > So. take a look at stuck_task... that's best backtrace I could get...
> > (I have other logs too. (Task-list / Lockdep / ... ) but it's too much
> > and I hope the _logs_ are already enough.
> > 
> > BTW: I noticed that the clock seems to jump forward and backwards.
> > Is this because the CPU-Cores aren't syncronized? (And why are they
> > out of sync?)

The cores of those AMD beasts are never in sync. That's a chip feature :)

Can you please provide the output of:
  /sys/devices/system/clocksource/clocksource0/current_clocksource 

for both 2.6.24 and 2.6.25-rc7

Thanks,
	tglx
