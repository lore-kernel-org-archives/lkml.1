Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbZE0X7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbZE0X7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZE0X7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:59:34 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:46207 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbZE0X7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:59:33 -0400
Message-ID: <4A1DD3A0.3010501@freescale.com>
Date: Wed, 27 May 2009 18:58:24 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb>	<fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>	<20090527150527.GK6805@pengutronix.de>	<fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com>	<20090527162000.GM6805@pengutronix.de>	<fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> <20090527234801.GP6805@pengutronix.de>
In-Reply-To: <20090527234801.GP6805@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> The oftree by design wants to be a complete hardware description. As you
> mention above, there are cases where you *nevertheless* need ad-hoc
> information about things *not* encoded into the device tree.
> 
> This renders the whole concept ad absurdum. You need a machine number
> again - and if you need that: why not stay with the ARM model, define
> everything with platform data and avoid the whole thing?

Because it's better to have a little platform specific code than a lot 
of it?

-Scott
