Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0CEUkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:40:42 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50376 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754725Ab0CEUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:40:37 -0500
Date: Fri, 5 Mar 2010 21:40:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq
 governor
Message-ID: <20100305204029.GB20554@elf.ucw.cz>
References: <20100303000649.757684000@intel.com>
 <20100303000849.278509000@intel.com>
 <4B8DADB9.1040302@xenotime.net>
 <20100303215453.GG2579@ucw.cz>
 <1267662469.16916.1020.camel@localhost.localdomain>
 <20100305091949.GA31554@atrey.karlin.mff.cuni.cz>
 <7C53B33EE871F14797C999838AA8B5A914ACD58C@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7C53B33EE871F14797C999838AA8B5A914ACD58C@orsmsx505.amr.corp.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >You should say what the setting does; you can mention below what MSR
> >it corresponds to, but "Control IA32_ENERGY_PERF_BIAS setting" is not
> >suitable user documentation.
> >
> >> Also, the expectation here is that kernel will do the right thing by
> >> default. The option here is to the user who_knows_what_he_is_doing to
> >> override the kernel default.
> >
> >You did not give user enough information to do anything intelligent...
> 
> I have rephrased it in the newer version sent yday with more info.

Good.

> >> > Also... does it make change to tweak the setting during 
> >runtime? Maybe
> >> > different settings for AC and battery power?
> >> 
> >> Yes. Matthew mentioned in other response aboue setting this based on
> >> freq. For the CPUs that support this feature currently, we don't see
> >> advantage in setting this feature at run time.
> >
> >If the feature is useless, then why set it at all?
> 
> I just said changing it at run time doesn't give us benefits. Not
>that

That can be only true if it does not give benefits period... AC and
battery power are quite different scenarios.

> the feature is useless. Having the default value for the tunable in
> mid-range does increase energy-efficiency than the tunable being
> at performance level.

So... what does it really do? What is the difference in power
consumption, and what is the difference in performance?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
