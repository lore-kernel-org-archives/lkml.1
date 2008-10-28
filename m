Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYJ1L7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYJ1L7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJ1L7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:59:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2193 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYJ1L7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:59:13 -0400
Date: Tue, 28 Oct 2008 11:59:09 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: eric miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support go?
Message-ID: <20081028115909.GC9068@sirena.org.uk>
References: <4906F500.7080100@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4906F500.7080100@cam.ac.uk>
X-Cookie: Visit beautiful Wisconsin Dells.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 11:18:24AM +0000, Jonathan Cameron wrote:

> The key one for me is control of the USB charge pump. So the question is, does
> this fit within the regulator framework (i.e. should I add it to the regulator
> driver) or should this be a seperate driver (and if so where?)

> Personally I'm not convinced it fits cleanly within the regulator framework
> given it is probably only ever going to get called from one driver and has
> somewhat odd properties!

What exactly does the USB charge pump control do here?  Is it purely
controlling the power supplied to USB (I'm assuming that this is the PXA
USB controller and that the DA903x is so closely tied to it nobody would
use it with another CPU)?  I'm guessing it's a bit more than that and
there's also control over the current that can be drawn from USB by the
system as well as that supplied.
