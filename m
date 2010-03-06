Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab0CFGoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 01:44:14 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40115 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750821Ab0CFGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 01:44:09 -0500
Date: Sat, 6 Mar 2010 07:43:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq
 governor
Message-ID: <20100306064359.GC28759@elf.ucw.cz>
References: <20100303000849.278509000@intel.com>
 <4B8DADB9.1040302@xenotime.net>
 <20100303215453.GG2579@ucw.cz>
 <1267662469.16916.1020.camel@localhost.localdomain>
 <20100305091949.GA31554@atrey.karlin.mff.cuni.cz>
 <7C53B33EE871F14797C999838AA8B5A914ACD58C@orsmsx505.amr.corp.intel.com>
 <20100305204029.GB20554@elf.ucw.cz>
 <20100305205522.GA15489@srcf.ucam.org>
 <20100305211329.GC20554@elf.ucw.cz>
 <20100305224909.GA21853@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305224909.GA21853@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-05 22:49:09, Matthew Garrett wrote:
> On Fri, Mar 05, 2010 at 10:13:30PM +0100, Pavel Machek wrote:
> > On Fri 2010-03-05 20:55:22, Matthew Garrett wrote:
> > > On Fri, Mar 05, 2010 at 09:40:29PM +0100, Pavel Machek wrote:
> > > 
> > > > That can be only true if it does not give benefits period... AC and
> > > > battery power are quite different scenarios.
> > > 
> > > No, they're not.
> > 
> > Yes, they are.
> > 
> > Would you care to elaborate? I may very well want top power on AC
> > power, and max powersavings on battery; most people do.
> 
> You may want that. But power constraints aren't limited to battery, and 
> being on battery doesn't inherently mean that you're power constrained. 
> Mixing these concepts results in all kinds of issues.

That's of course true.

But if something gives so limited benefit that it does not make sense
to tweak between power constrained and not-power-constrained
environments (I used AC and battery as an example), it is useless.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
