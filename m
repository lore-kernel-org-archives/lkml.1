Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYHMUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYHMUny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHMUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:43:42 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44768 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701AbYHMUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:43:42 -0400
Date: Wed, 13 Aug 2008 16:43:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: thinkpad x60 is cooled passively
Message-ID: <20080813204338.GA6142@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20080813080618.GA16061@elf.ucw.cz> <20080813152431.GD8232@mit.edu> <20080813203137.GB27546@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813203137.GB27546@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 05:31:37PM -0300, Henrique de Moraes Holschuh wrote:
> > know the fans have a tendency to go bad within 12-18 months, and so
> > the CPU heat sink and fan unit needs to be replaced perdiocially.
> > What does /proc/acpi/ibm/fan report? 
> 
> ThinkPad fans have a overdesign range of about 2x, they almost never stop
> because they're too old.  Clogged in dirt, on the other hand... a clogged
> fan often spins FASTER and cools less.
> 
> Want to see how much your fan has as far as a safety margin goes? use
> thinkpad-acpi to measure RPMs in level 7 and also when you switch PWM off
> (i.e. set it to 100% duty cycle).  Mine gets faster by 1500RPM or so that
> reflects the extra torque the EC can apply to get the fan to run at the
> speed it wants it to.

Hmm, maybe I've just had bad luck, or I live in a very dusty
environment (four cats, including two longhairs in perma-shed mode,
will do that to any house), but I've had at least 3 fan failures in
the past 5-6 years where the fan stopped entirely, and had to be
replaced.  When I took it out, it was quite dirty, but the way it spun
why I tried moving the fan blades with my finger, it felt just like
the failure modes I've had with standard power supply fans that have
gone bad due to old age.

       	    	      	       	      - Ted

