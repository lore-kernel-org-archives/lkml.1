Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYGDVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYGDVNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYGDVNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:13:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1442 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYGDVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:13:08 -0400
Date: Fri, 4 Jul 2008 22:13:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PalmTX initial support
Message-ID: <20080704211306.GD20719@sirena.org.uk>
Mail-Followup-To: Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <200807022232.47294.marek.vasut@gmail.com> <g4li2u$l3c$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g4li2u$l3c$1@ger.gmane.org>
X-Cookie: No stopping or standing.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 04:11:10PM +0000, Dmitry Baryshkov wrote:

> Please consider switching ac97 driver to ASoC-based one.

There was another patch posted with an ASoC machine driver so I guess
this is covered :) .  Registering the AC97 platform device is still
useful for platforms using ASoC - it doesn't hurt at the minute and when
the ASoC v2 changes allowing different components to load separately it
will be used to load the ASoC AC97 controller driver.
