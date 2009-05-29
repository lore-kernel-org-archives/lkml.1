Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbZE2MeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbZE2MeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZE2MeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:34:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56569 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757859AbZE2MeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:34:11 -0400
Date: Fri, 29 May 2009 13:34:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       scottwood@freescale.com, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       yuan-bo.ye@motorola.com, timur@freescale.com, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090529123411.GB14650@rakim.wolfsonmicro.main>
References: <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de> <20090527.171525.204909140.davem@davemloft.net> <20090528103745.GA19523@sirena.org.uk> <fa686aa40905281532l76996593ocdc36760eb468e04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40905281532l76996593ocdc36760eb468e04@mail.gmail.com>
X-Cookie: Put your trust in those who are worthy.
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 04:32:40PM -0600, Grant Likely wrote:

> and half-assed example of this).  However, when it comes to complex
> configurations that cannot be easily described, I'm all for using
> platform specific code.

Indeed, and I do appreciate this.  The problem in the audio area is more
when new people come along since everyone working with the device tree
expects to be able to use the device tree to cover everything which
means going round things again and explaining how non-trivial that would
be.

> In fact, I may have been premature in pursuing the generic description
> and generic fabric driver approach for the MPC5200 audio driver.  It
> may have been better to get a few similar MPC5200 boards under our
> belt before trying to identifying the common cases.

Sure.  My only big concern with it is that it compeltely sidesteps
clocking decisions so there's a lot of codecs it's not going to be
immediately useful with and I don't have a clear idea how it could be
extended to be so.  Most other things look like they can be added on
fairly easily when required.

It'd also be nice if there were a way for systems to say that they're
able to use it but that's getting back to the whole OS-specifics in the
device tree thing.
