Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZCWPmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZCWPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZCWPmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:42:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZCWPmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:42:09 -0400
Date: Mon, 23 Mar 2009 16:41:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Avi Kivity <avi@redhat.com>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: phenom, amd780g, tsc, hpet, kvm, kernel -- who's at fault?
Message-ID: <20090323154137.GA1259@elte.hu>
References: <49BACABE.7060003@msgid.tls.msk.ru> <20090323080441.GA27170@elte.hu> <49C748EA.6040809@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C748EA.6040809@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Tokarev <mjt@tls.msk.ru> wrote:

> Now, after quite some googling around, I tried to disable hpet, 
> booting with hpet=disable parameter.  And that one fixed all the 
> problems at once. 7 days uptime, I stress-tested it several times, 
> it works with TSC as timesource (still a problem within guests as 
> those shows unstable TSC anyway) since boot, no issues logged.  
> Even cpufreq works as expected...
>
> Note that i tried to disable hpet as clocksource several times but 
> without any noticeable effect - kernel still used hpet and hpet2 
> for something, and printed that scary "increasing min_delay" 
> message on a semi-regular basis usually after the next 'stuck' 
> state....

It could again go bad like it did before - those messages are signs 
of HPET weirdnesses.

Probably your box's hpet needs to be blacklisted, so that it gets 
disabled automatically on bootup.

	Ingo
