Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZATMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZATMnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZATMno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:43:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2250 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbZATMnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:43:43 -0500
Date: Tue, 20 Jan 2009 12:43:41 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>
Subject: Re: regulator: Add always off to constraints.
Message-ID: <20090120124338.GA31521@sirena.org.uk>
References: <4975BE69.5040106@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975BE69.5040106@cam.ac.uk>
X-Cookie: This end up.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:07:05PM +0000, Jonathan Cameron wrote:

> 1) interaction between always on and always off.  Obviously it's
> a bit odd if both are set. Currently I'm giving always on preference.

I'd just complain loudly and refuse to accept the constraints if they
are clearly broken like that.

One thing I would suggest is a slightly weaker version which marks the
regulator to be turned off at boot rather than always off.  That's
slightly more flexible and would achieve the same effect if the
constraints don't otherwise allow for turning the regulator on layer.

> 2) Doesn't really make sense to have regulators that are always
> disabled available under sysfs etc.  Perhaps there is a lower
> level way of doing this that I'm missing?  There is not easy
> way of permanently saving this stuff on the da9030 that I'm
> using and moving it into the bootloader would be a pain.

It doesn't do *that* much harm - if nothing else it makes it more
discoverable what's happening.
