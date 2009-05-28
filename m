Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZE1Hjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZE1Hjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZE1Hje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:39:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:51505 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZE1Hjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:39:33 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090527175609.GB31861@flint.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk>
	 <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 28 May 2009 17:37:16 +1000
Message-Id: <1243496236.3171.140.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 18:56 +0100, Russell King wrote:
> 
> smc91x is a prime example of the kind of information drivers need - base
> address and irq are very much insufficient to describe how this device is
> connected.  There's much more information required to specify this device
> fully, and throwing it into the driver doesn't work.  We've been there
> and proven that point.

The device-tree is a very nice and convenient way to convey all the
informations the driver need straight to the driver without any platform
code in the middle :-)

Cheers,
Ben.


