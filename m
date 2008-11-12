Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYKLXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYKLXJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYKLXJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:09:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3903 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKLXJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:09:06 -0500
Date: Wed, 12 Nov 2008 23:09:03 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Message-ID: <20081112230901.GA8272@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <200811102056.20008.david-b@pacbell.net> <20081112112525.GA8767@sirena.org.uk> <200811121342.36117.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811121342.36117.david-b@pacbell.net>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 01:42:35PM -0800, David Brownell wrote:
> On Wednesday 12 November 2008, Mark Brown wrote:

> > It should be a separate patch, I'd say.

> So you think I should split my "v2" patch in two chunks?
> One distinguishing requested-vs=actual mode, and the other
> allowing the actual mode to include OFF.  (Possibly by just
> reporting mode 0 ...)

I would certainly keep OFF as a separate patch, yes.

> > Thinking about it I'm not sure if the hardware or logical state should
> > be the primary.  In terms of debugging power consumption and so on the

> If there are both "requested opmode" and "opmode" attributes
> in sysfs, I don't see how one would be "primary"!

The one returned by the in-kernel get_mode() and reported as "opmode" is
what I'd think of as primary.
