Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYIHN17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYIHN17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYIHN1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:27:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55969 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYIHN1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:27:50 -0400
Date: Mon, 8 Sep 2008 15:29:12 +0200
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: thinkpad x60 is cooled passively
Message-ID: <20080908132912.GB18486@elf.ucw.cz>
References: <20080813080618.GA16061@elf.ucw.cz> <20080813152431.GD8232@mit.edu> <20080813203137.GB27546@khazad-dum.debian.net> <20080813204338.GA6142@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813204338.GA6142@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-13 16:43:38, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 05:31:37PM -0300, Henrique de Moraes Holschuh wrote:
> > > know the fans have a tendency to go bad within 12-18 months, and so
> > > the CPU heat sink and fan unit needs to be replaced perdiocially.
> > > What does /proc/acpi/ibm/fan report? 
> > 
> > ThinkPad fans have a overdesign range of about 2x, they almost never stop
> > because they're too old.  Clogged in dirt, on the other hand... a clogged
> > fan often spins FASTER and cools less.
> > 
> > Want to see how much your fan has as far as a safety margin goes? use
> > thinkpad-acpi to measure RPMs in level 7 and also when you switch PWM off
> > (i.e. set it to 100% duty cycle).  Mine gets faster by 1500RPM or so that
> > reflects the extra torque the EC can apply to get the fan to run at the
> > speed it wants it to.
> 
> Hmm, maybe I've just had bad luck, or I live in a very dusty
> environment (four cats, including two longhairs in perma-shed mode,
> will do that to any house), but I've had at least 3 fan failures in
> the past 5-6 years where the fan stopped entirely, and had to be
> replaced.  When I took it out, it was quite dirty, but the way it spun
> why I tried moving the fan blades with my finger, it felt just like
> the failure modes I've had with standard power supply fans that have
> gone bad due to old age.

Okay, seems like vojtech fixed my notebook with a bit of compressed
air... a lot of dust came out, and machine works okay now.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
