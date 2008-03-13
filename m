Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYCMMS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYCMMS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYCMMSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:18:20 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:51752 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYCMMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uQ5byvzZhbRxRlpSHxhDBWHlAteYUcKah/34j1adPOSd8+VEq+NeNhVW9DsTYFhl3eGrVKCkj0GMCkWbpF04QoT9WZ3bMvXv6SKAi2r3SUmlc6+RB+YNCI15I2aqRdHhlZak/BLTZ9ByU3Yz8ZL/AKF3ZB5CT6ax9J5K0nZby1s=
Date: Thu, 13 Mar 2008 09:19:01 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
       linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
Subject: Re: Keys get stuck
Message-ID: <20080313121900.GA4095@localhost.ift.unesp.br>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
	linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
	David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
	"Fred ." <eldmannen@gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net> <20080313120238.GA3860@localhost.ift.unesp.br> <Pine.LNX.4.64.0803131305540.30831@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803131305540.30831@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13.Mar'08 at 13:06:53 +0100, Jiri Kosina wrote:
> On Thu, 13 Mar 2008, Carlos R. Mafra wrote:
> 
> > So I would like to ask if swap letting X (and everything else in my 
> > experience) out of the cpu for extended periods is considered normal 
> > behaviour, in the sense that nobody is trying to "fix" it (due to it 
> > being considered impossible to fix)...? Sorry for being off-topic, but I 
> > run a minimal Window Maker desktop in a P4 3.0 GHz with 512 MB of RAM 
> > (around 140 MB being used as per 'free'), and trying to load a 380 MB 
> > text file in xjed editor makes my whole desktop quite unfair... it takes 
> > tens of seconds to switch desktop, type things in the terminal etc. When 
> > xjed finishes loading the text file, everything comes back to "fair" 
> > again.
> 
> I propose you start a new thread about this with proper Subject, and CC 
> the scheduler maintainers.

Right. I am sorry!

But the thing I've learned from:

http://lkml.org/lkml/2008/2/28/249

makes me _not_ think the scheduler is guilty by itself.
Although it may appear so when first-looked upon.

Now I think that the  problem I was facing that day was
also caused by swapping, which makes everything else
wait for it to finish.

So I am sorry for going off-topic here, but I couldn't
resist asking Galbraith about it.

Or I should just start a new thread like this? :-)

Petition for Ingo writing CFSS: Completely Fair Swap Scheduler



