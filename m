Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZD1J7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZD1J7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZD1J64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:58:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:60407 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZD1J6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=pe5LkBQ/W9SGR06Fml1q5aSs0rSKT+htarDrGAGAaZi2EM8IhFE0eYMkitcIZcdhfI
         PZBbi7PGHDor9NQ3etdC36jvpv9Iu51AbuHbMeAnz9XecbfEhHmaSCXejOofZPRIbaKL
         JFoptXoi5yj0AjiCyci1+jqhG965mx84bcqaM=
Date: Tue, 28 Apr 2009 17:56:51 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org
Subject: [PATCH] fix some section mismatch on drivers/hwmon/sht15.c
Message-ID: <20090428095651.GA9694@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix those section mismatch wornings:

WARNING: drivers/hwmon/sht15.o(.data+0x0): Section mismatch in reference from
the variable sht_drivers to the function .devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0x4): Section mismatch in reference from
the variable sht_drivers to the function .devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0x50): Section mismatch in reference from
the variable sht_drivers to the function .devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0x54): Section mismatch in reference from
the variable sht_drivers to the function .devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0xa0): Section mismatch in reference from
the variable sht_drivers to the function .devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0xa4): Section mismatch in reference from
the variable sht_drivers to the function .devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0xf0): Section mismatch in reference from
the variable sht_drivers to the function .devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0xf4): Section mismatch in reference from
the variable sht_drivers to the function .devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0x140): Section mismatch in reference from
the variable sht_drivers to the function .devinit.text:sht15_probe()
The variable sht_drivers references
the function __devinit sht15_probe()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: drivers/hwmon/sht15.o(.data+0x144): Section mismatch in reference from
the variable sht_drivers to the function .devexit.text:sht15_remove()
The variable sht_drivers references
the function __devexit sht15_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,



Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/hwmon/sht15.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 6cbdc2f..18061d2 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -620,7 +620,7 @@ static int __devexit sht15_remove(struct platform_device *pdev)
 }
 
 
-static struct platform_driver sht_drivers[] = {
+static struct platform_driver __refdata sht_drivers[] = {
 	{
 		.driver = {
 			.name = "sht10",
-- 
1.5.6.5

-- 
--------------------------------
http://zhwen.org - Open and Free
