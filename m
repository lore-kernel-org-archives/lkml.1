Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYHMUbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYHMUbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYHMUbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:31:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60667 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYHMUbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:31:42 -0400
Date: Wed, 13 Aug 2008 22:32:59 +0200
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: thinkpad x60 is cooled passively
Message-ID: <20080813203259.GD8861@elf.ucw.cz>
References: <20080813080618.GA16061@elf.ucw.cz> <20080813152431.GD8232@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813152431.GD8232@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-13 11:24:31, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 10:06:18AM +0200, Pavel Machek wrote:
> > While verifying that -rc2 regression is gone, I noticed alarming
> > stuff:
> > 
> > 1) thinkpad x60 relies on passive cooling. You have nice 1.8GHz cpu,
> > which goes away as soon as you load it.
> > 
> > 2) after some time it decides that 100% cpu in 1.0GHz is fine for you,
> > and it takes quite long to recover.
> 
> There is no fan in the X60?  I didn't think that was the case.  I do
> know the fans have a tendency to go bad within 12-18 months, and so
> the CPU heat sink and fan unit needs to be replaced perdiocially.
> What does /proc/acpi/ibm/fan report? 

3700 on level 7, more (like 4700) on disengaged, but still not enough
to keep it from going to 1GHz.

> Or are you saying that the fan isn't keeping keeping up with the heat
> output of the CPU?  Are you sure this isn't due to a hardware
> problem?

Yes, I'm trying to say that the fan isn't keeping keeping up with the
heat output of the CPU.

> As mentioned previously on this list, Lenovo has had a relatively bad
> track record with fan failures and with incompetent installation of
> the heat sink with bad applications of the thermal compound; it's the
> one failings of an otherwise very nice laptop design.

Hmm, ok, maybe. It is true that nearby X60p behaved slightly
differently.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
