Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZLOOuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZLOOuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbZLOOuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:50:06 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51192 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbZLOOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:50:03 -0500
Subject: Re: [PATCH 4/4] regulator: mc13783-regulator: correct the probing
 time.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <1260813215.2022.171.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
	 <1260811085.2022.135.camel@climbing-alby>
	 <1260811598.2022.144.camel@climbing-alby>
	 <1260813215.2022.171.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 14:50:01 +0000
Message-ID: <1260888601.3591.552.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 18:53 +0100, Alberto Panizzo wrote:
> When the mc13783-regulator driver is built in kernel, probing it during
> the regulator subsystem initialisation result in a fault.
> 
> That is because regulator subsystem is planned to be initialised very early
> in the boot process, before the mfd subsystem initialisation.
> 
> The mc12783-regulator probing process need to access to the mc13783-core
> functionality to read/write mc13783 registers and so must be called after
> the mc13783-core driver initialisation.
> 
> The way to do this is to let the kernel probe the mc13783-regulator driver when 
> mc13783-core register his regulator subdevice.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Applied to 2.6.33

Thanks

Liam

