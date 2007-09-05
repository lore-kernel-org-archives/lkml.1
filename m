Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXIEJWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXIEJWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXIEJWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:22:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbXIEJWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:22:13 -0400
Date: Wed, 5 Sep 2007 10:22:30 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Rob Sims <lkml-z@robsims.com>
Cc: Adrian Bunk <bunk@stusta.de>, Kyle Rose <krose@akamai.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070905102230.10b0bdcf@oldman>
In-Reply-To: <20070730030130.GA6893@robsims.com>
References: <46A8BAD4.8020004@akamai.com>
	<20070726165701.GM3572@stusta.de>
	<20070730030130.GA6893@robsims.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 21:01:30 -0600
Rob Sims <lkml-z@robsims.com> wrote:

> On Thu, Jul 26, 2007 at 06:57:01PM +0200, Adrian Bunk wrote:
> > On Thu, Jul 26, 2007 at 11:16:36AM -0400, Kyle Rose wrote:
> > > >From http://www.krose.org/~krose/computing.html:
> > > 
> > > Since the sky2 driver continues to suck ass (which is a technical
> > > description for "it hangs all the time under load, at least on my
> > > hardware" :-) ), I've fixed the sk98lin driver to compile for
> > > linux-2.6.23-rc1. Those who continue to have problems with sky2 can
> > > still use 2.6.23-rc1, simply by doing the following:
> > >...
> > > Personally, I'd like to see sk98lin remain in the kernel proper until
> > > sky2 goes at least 6 months without reported problems.  The fact that I
> > > am not the only one still seeing issues is a clear indication that sky2
> > > (even with the recent patches in 2.6.23-rc1) is not yet ready to replace
> > > sk98lin.
> > >...
> > 
> > This sounds good in theory.
> > 
> > The practical problem with this approach is that there are always many 
> > people who use the old driver when the new driver doesn't work for them 
> > instead of reporting their problems with the new driver.
> > 
> > For these people a new driver will often suck when the old driver gets 
> > removed, but after the removal of the old driver they are finally forced 
> > to report their bugs resulting in a better new driver for everyone.
> > 
> > The sky2 driver is since nearly 2 years in the kernel and Stephen is 
> > usually quite good at handling bugs.
> 
> The driver still (2.6.20/sky2 1.13) hangs for me (more rarely than in
> the past), and cycling the module generally fixes the issues.  I have
> supplied all the information that Stephen has asked for, but still no
> resolution.  I am not complaining about the lack of a fix, but don't
> assume that all it takes to get sky2 working is adequate bug reports.  I
> have been and remain willing to test and assist debug, but after several
> dropped threads, I feel like the desire or ability to fix this issue
> isn't there (and remote debug of an intermittent hardware issue IS
> hard), and I didn't want to be a nuisance to someone that has no
> obligation to me to address the issue in the first place.
> 
> Stability has improved, it's just not there yet.
> 
> I'll switch to 1.16 soon, and respond to Stephen's request on netdev for
> current issues.
> -- 
> Rob

The only known outstanding problems on 2.62.22.6 of sky2 are:
 * problems with fibre PHY based systems
 * suspend/resume issues, missing multicast reinitalization, etc.
The previous stability problems have been addressed.
