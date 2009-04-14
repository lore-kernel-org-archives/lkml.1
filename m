Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZDNInL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZDNInL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZDNIm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:42:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZDNImz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:42:55 -0400
Date: Tue, 14 Apr 2009 10:42:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30-rc1 - nmi_watchdog broken?
Message-ID: <20090414084232.GG27003@elte.hu>
References: <200904140000.30155.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904140000.30155.edt@aei.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ed Tomlinson <edt@aei.ca> wrote:

> Hi,
> 
> I've been having fun finding bugs in 30-rc1.  One of them is a 
> hard freeze.  I've not seen this type of problem on this hardware 
> before 30-rc1 - so I doubt if its hardware.  The best way I know 
> to debug a hard hang is with the nmi_watchdog.  I just cannot get 
> it to work.

[ Btw., have you tried CONFIG_PROVE_LOCKING=y - does it produce
  anything before or at the hard lockup point? ]

> The system is a 3 core amd cpu on a 790gx chipset.
> 
> If I boot the nmi_watchdog=1 it complains that lapci is not 
> available and the boot stops.  Same problem if I change the 
> clocksource to tsc, If I disable highres timers it panics.  If I 
> use nmi_watchdog=2 it panics. Am I doing something wrong or have I 
> hit a bug?
> 
> Logs of boots with and without highres timers inlined below.

hm, nmi_watchdog=1 acting funny is not unheard of. But 
nmi_watchdog=2 should really work. How does it panic, do
you have a capture of that?

	Ingo
