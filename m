Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZAMLjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZAMLjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZAMLjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:39:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3185 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZAMLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:39:22 -0500
Date: Tue, 13 Jan 2009 11:39:19 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move wm8400-regulator's probe function to .devinit.text
Message-ID: <20090113113917.GC11651@sirena.org.uk>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <1231799107-20136-60-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231799107-20136-60-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: Androphobia:
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:25:05PM +0100, Uwe Kleine-K??nig wrote:
> A pointer to wm8400_regulator_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.

> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
