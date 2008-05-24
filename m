Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYEXOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYEXOdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYEXOcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:32:53 -0400
Received: from mail0.scram.de ([78.47.204.202]:33514 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbYEXOcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:32:52 -0400
X-Spam-Score: -4.11
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <48382710.9030700@scram.de>
Date: Sat, 24 May 2008 16:32:48 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Gary Jennejohn <garyj@denx.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi
 driver
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>	<20080523182842.GB469@polina.dev.rtsoft.ru> <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
In-Reply-To: <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

>> +      - compatible : should be "linux,mmc-spi".
>> +      - linux,modalias  - should be "of_mmc_spi".
> 
> I'm not even sure if the whole linux,modalias is even a good idea.  I
> had kind of thrown it in there as a convenient way to override
> compatible when needed, but I haven't really thought it out very well
> and I think it is rather a hack.
> 
> The real problem is we don't yet have good method (or place) to apply
> a translation table from compatible values to modaliases.  Ideally,
> the translations should be part of the drivers themselves, but that
> causes a chicken and egg problem of needing to load the driver to get
> access to the table to know if it is the correct driver... Of course,
> I'm really not very familiar with the whole module autoloading
> mechanism.  Regardless; binding should be based on compatible, not on
> a hacky and bogus linux,modalias property.

i2c exactly has the same problem. Here the compatible entry is used
in drivers/of/of_i2c.c and mangled into a name to be used as modalias.
It's still sort of hackish, but it seems to be a compromise acceptable
by both OF and i2c folks.

Thanks,
Jochen
