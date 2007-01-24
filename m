Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXAXULI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXAXULI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXAXULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:11:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbXAXULF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:11:05 -0500
Date: Wed, 24 Jan 2007 21:09:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: John <me@privacy.net>, linux-kernel@vger.kernel.org, tglx@timesys.com,
       akpm@osdl.org, shill@free.fr
Subject: Re: One-shot high-resolution POSIX timer periodically late
Message-ID: <20070124200947.GA925@elte.hu>
References: <45B729AF.4030701@privacy.net> <1169665347.6905.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1169665347.6905.3.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2007-01-24 at 10:41 +0100, John wrote:
> > I'm using the POSIX timers API. My platform is x86 running Linux
> > 2.6.18.6 patched with the high-resolution timer subsystem.
> > 
> > http://www.tglx.de/hrtimers.html

> > My process is the only SCHED_FIFO process on the system. There are 
> > no user-space processes with a higher priority. AFAICT, only a 
> > kernel thread could keep the CPU away from my app.
> > 
> > Is there a periodic kernel thread that runs every 2 seconds, cannot 
> > be preempted, and runs for over 50 µs??
> 
> This sounds like a BIOS SMI issue. Can you reproduce this behavior on 
> different hardware?

note that only the -hrt patchset is used - not the full -rt patchset - 
so 50 usecs delays (and more) are quite possible and common.

My question would be: does the same problem occur with the full -rt 
patchset and PREEMPT_RT? (see http://rt.wiki.kernel.org for details)

	Ingo
