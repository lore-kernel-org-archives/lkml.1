Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZFBJsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZFBJsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZFBJsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:48:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33929 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751894AbZFBJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:48:10 -0400
Date: Tue, 2 Jun 2009 10:48:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>, timur@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090602094811.GC19390@rakim.wolfsonmicro.main>
References: <20090527234801.GP6805@pengutronix.de> <1243677166.440.12.camel@pasglop> <20090530102153.GA6910@n2100.arm.linux.org.uk> <200906020957.20493.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020957.20493.hs4233@mail.mn-solutions.de>
X-Cookie: QUESTION AUTHORITY.
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:57:20AM +0200, Holger Schurig wrote:

> > 1. implementers of the clock API which have not been subject
> > to my rigorous review abuse it to the point of making the API
> > essentially useless, and that causes Mark problems.

> If that's a problem, when something needs changes. An API that 
> can only be managed by implementers due to rigorous review lacks 
> something, maybe easy-of-use, maybe documentation. Can it be the 
> case that the current state makes you a single-point of failure?

The problem is more that a lot of platform maintainers have treated the
clock API as being a bit of platform support code not intended to be
used by drivers, causing them to take lots of shortcuts when
implementing it that only work in their specific use cases - at times to
the point where it's not even possible to register new clocks.  Since
this means that the API is essentially unusable in generic driver code
you end up with nobody using it there and no back pressure other than
code review on maintainers to provide a good implementation.

> If yes, I'd at least suggest better docs in linux/Documentation, 
> e.g. describe the big-picture, the implementation and common 
> cave-ats, e.g. why an approach "uniquely name every single 
> clock ... makes the API pointless" doesn't work.

None of which means that better documentation wouldn't help, of course.
