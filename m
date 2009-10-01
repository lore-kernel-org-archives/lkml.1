Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZJAI3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZJAI3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbZJAI3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:29:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56614 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbZJAI3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:29:31 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
       Ben Dooks <ben@simtec.co.uk>, Ramax Lo <ramaxlo@gmail.com>,
       Nelson Castillo <arhuaco@freaks-unidos.net>
Subject: [PATCH 19/34] move s3c_adc_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:23 +0200
Message-Id: <1254385718-14254-19-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function s3c_adc_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Ramax Lo <ramaxlo@gmail.com>
Cc: Nelson Castillo <arhuaco@freaks-unidos.net>
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/plat-s3c24xx/adc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-s3c24xx/adc.c b/arch/arm/plat-s3c24xx/adc.c
index 11117a7..4606072 100644
--- a/arch/arm/plat-s3c24xx/adc.c
+++ b/arch/arm/plat-s3c24xx/adc.c
@@ -364,7 +364,7 @@ static int s3c_adc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int s3c_adc_remove(struct platform_device *pdev)
+static int __devexit s3c_adc_remove(struct platform_device *pdev)
 {
 	struct adc_device *adc = platform_get_drvdata(pdev);
 
-- 
1.6.4.3

