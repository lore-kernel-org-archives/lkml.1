Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbZLOOyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbZLOOyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbZLOOyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:54:45 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52827 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426AbZLOOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:54:44 -0500
Subject: Re: [PATCH 3/4] regulator: add voltage selection capability to
 mc13783 regulators v2 .
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1260811598.2022.144.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
	 <1260811085.2022.135.camel@climbing-alby>
	 <1260811598.2022.144.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 14:54:42 +0000
Message-ID: <1260888882.3591.559.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 18:26 +0100, Alberto Panizzo wrote:
> This patch, complete the mc13783 regulator subsystem driver with 
> voltage selecting capability.
> Main Switches (SW1AB, SW2AB) are not supported yet.
> 
> version 2 diffs:
> - delete the "Switchers PLL" enable and multiplication factor value 
>   selecting capability because it is not a voltage or current regulator.
>   This will be a part of Main switcher supporting task.
> - Correct many coding style problems pointed me out.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/mc13783-regulator.c |  345 ++++++++++++++++++++++++++++++---
>  1 files changed, 315 insertions(+), 30 deletions(-)

Applied.

Thanks

Liam

