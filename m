Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbZE0Qcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbZE0Qcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZE0Qcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:32:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44714 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759865AbZE0Qci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:32:38 -0400
Date: Wed, 27 May 2009 17:32:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527163223.GE1970@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527150527.GK6805@pengutronix.de>
X-Cookie: Don't get even -- get odd!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:05:27PM +0200, Robert Schwebel wrote:

> I'm highly convinced that the existence of oftree-hell in ARM-land would
> have been *the* key motivation for FSL to have worked on mainline
> instead of inhouse-BSPs back in 2004 when we mainlined i.MX1 and in 2007
> when we started the mainline work on MX27 and MX31.

I remain to be convinced about that but anyway..

> Seriously: oftree in general is a good idea. Just that it doesn't work
> in practise. The concept has some serious flaws:

> - Platform data makes it possible to store function pointers. There
>   is no equivalent to this concept in oftree-land.

The handling of platform data is my main concern as someone working
primarily on platform independant drivers - function pointers are a
particular problem but the possibility of having to write code to
handle both OF and non-OF systems to cater for systems using both
approaches is also a concern for me.

> oftree could be a great tool if these things would be resolved.
> Currently they are not, and in result, ARM just works and is easy,
> whereas on PowerPC systems people often spend more time working on
> binding stuff than on the actual functionality.

This worries me too, my experiences with OF device tree handling for
ASoC have been pretty negative - but then audio is one of the worst
cases for handling within the device tree.
