Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXFLHcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXFLHcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXFLHcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:32:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXFLHco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:32:44 -0400
Date: Tue, 12 Jun 2007 09:32:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070612073207.GA32646@elte.hu>
References: <20070609210507.GA29194@elte.hu> <1181628181.7641.15.camel@perkele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181628181.7641.15.camel@perkele>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Venki for the force-hpet issue below)

* Eric St-Laurent <ericstl34@sympatico.ca> wrote:

> On Sat, 2007-09-06 at 23:05 +0200, Ingo Molnar wrote:
> > i'm pleased to announce the v2.6.21.4-rt11 kernel, which can be 
> > downloaded from the usual place:
> 
> I'm running 2.6.21.4-rt12-cfs-v17 (x86_64), so far no problems. I like 
> this kernel a lot, it's feels quite smooth.

yeah, that's probably CFS in the works :-) That combined with PREEMPT_RT 
makes for a really snappy desktop.

> One little thing, no HPET timer is detected. By looking at the patch, 
> even the force detect code is there, it should work.
> 
> The hpet timer is not available as a clocksource and only one hpet
> related message is present in dmesg:
> 
> PM: Adding info for No Bus:hpet
> 
> This is on a Asus P5LD2-VM motherboard (ICH7)
> 
> Relevant config bits:
> 
> CONFIG_HPET_TIMER=y
> # CONFIG_HPET_EMULATE_RTC is not set
> CONFIG_HPET=y
> # CONFIG_HPET_RTC_IRQ is not set
> CONFIG_HPET_MMAP=y
> 
> Should I enable one of the two other options? Any ideas?

Venki, is this ICH7 board supposed to work with force-hpet?

	Ingo
