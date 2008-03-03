Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbYCCVIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbYCCVIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYCCVIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:08:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60729 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYCCVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:08:09 -0500
Date: Mon, 3 Mar 2008 22:08:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303210839.GJ13869@elf.ucw.cz>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx> <20080303211842.6f492782@mjolnir.drzeus.cx> <20080303204603.GA19775@elf.ucw.cz> <20080303220310.0cab7213@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303220310.0cab7213@mjolnir.drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-03 22:03:10, Pierre Ossman wrote:
> On Mon, 3 Mar 2008 21:46:03 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > >  
> > > +static unsigned int min_deep_sleep = 2000;
> > > +
> > 
> > Well, why not, but I believe we should default to old behaviour... not
> > all machines are cheaply-build.
> 
> One would hope. ;)
> 
> But the problem is that most people will not be able to find this
> option (or even know such an option exists). I'd guess the distros will
> just end up having this on by default anyway. And since I could not
> measure any extra power drain, I believe it's hard to justify having it
> off by default (more than by pure principle).

So just leave it off by default, and let distros break their own
kernels ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
