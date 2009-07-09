Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZGJMU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZGJMU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZGJMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:20:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZGJMUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:20:13 -0400
Date: Fri, 10 Jul 2009 01:34:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency
	increase
Message-ID: <20090709233447.GA1770@ucw.cz>
References: <200907081556.34682.czoccolo@gmail.com> <20090708161052.GA20951@srcf.ucam.org> <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 19:41:23, Corrado Zoccolo wrote:
> Hi Matthew,
> 
> On Wed, Jul 8, 2009 at 6:10 PM, Matthew Garrett<mjg@redhat.com> wrote:
> > On Wed, Jul 08, 2009 at 03:56:33PM +0200, Corrado Zoccolo wrote:
> >> The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
> >> as found in conservative governor, to chose the frequency increase step,
> >> expressed as percentage (default = 100 is previous behaviour).
> >>
> >> This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
> >> * absorb punctual load spikes
> >> * stabilize at the needed frequency, without passing for more power consuming states, and
> >
> > Is this a measured powersaving? The ondemand model is based on the
> > assumption that the idle state is disproportionately lower in power than
> > any running state, and therefore it's more sensible to run flat out for
> > short periods of time than run at half speed for longer. Is this
> > inherently flawed, or is it an artifact of differences in your processor
> > design?

Different processors behave differently -- that assumption is wrong at
least for old athlon64s... Those have power-hungry idle states, and 4x
power consumption at 2x frequency....

(Original Intel speedstep was similar iirc).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
