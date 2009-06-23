Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZFWKOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZFWKOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZFWKN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:13:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38776 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZFWKNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:13:55 -0400
Date: Tue, 23 Jun 2009 11:13:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Green <andy@warmcat.com>,
       Ben Dooks <ben-linux@fluff.org>, Michel Pollet <buserror@gmail.com>
Message-ID: <20090623101344.GF5422@sirena.org.uk>
References: <20090623162223.55b9880c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623162223.55b9880c.sfr@canb.auug.org.au>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: origin tree build failure
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix it, I'll submit to the patch system immediately.

>From 196ab1662fc5561ca304bb4d08160f085a8f171d Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 23 Jun 2009 11:08:08 +0100
Subject: [PATCH] [ARM] S3C24XX: Declare device for IIS ports

Though the device is not actually used by the drivers on S3C24xx CPUs
some platforms register it causing build failures.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/arm/plat-s3c/include/plat/devs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-s3c/include/plat/devs.h b/arch/arm/plat-s3c/include/plat/devs.h
index b5b9c4d..71a6b0e 100644
--- a/arch/arm/plat-s3c/include/plat/devs.h
+++ b/arch/arm/plat-s3c/include/plat/devs.h
@@ -34,6 +34,7 @@ extern struct platform_device s3c_device_lcd;
 extern struct platform_device s3c_device_wdt;
 extern struct platform_device s3c_device_i2c0;
 extern struct platform_device s3c_device_i2c1;
+extern struct platform_device s3c_device_iis;
 extern struct platform_device s3c_device_rtc;
 extern struct platform_device s3c_device_adc;
 extern struct platform_device s3c_device_sdi;
-- 
1.6.3.1

