Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbZFBH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbZFBH5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbZFBH5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:57:05 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:2255 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623AbZFBH5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:57:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Date: Tue, 2 Jun 2009 09:57:20 +0200
User-Agent: KMail/1.9.7
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, timur@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       David Miller <davem@davemloft.net>
References: <20090527234801.GP6805@pengutronix.de> <1243677166.440.12.camel@pasglop> <20090530102153.GA6910@n2100.arm.linux.org.uk>
In-Reply-To: <20090530102153.GA6910@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020957.20493.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. implementers of the clock API which have not been subject
> to my rigorous review abuse it to the point of making the API
> essentially useless, and that causes Mark problems.

If that's a problem, when something needs changes. An API that 
can only be managed by implementers due to rigorous review lacks 
something, maybe easy-of-use, maybe documentation. Can it be the 
case that the current state makes you a single-point of failure?

If yes, I'd at least suggest better docs in linux/Documentation, 
e.g. describe the big-picture, the implementation and common 
cave-ats, e.g. why an approach "uniquely name every single 
clock ... makes the API pointless" doesn't work.
