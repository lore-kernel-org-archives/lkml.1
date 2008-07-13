Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYGMBxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYGMBxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYGMBxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:53:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbYGMBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:53:07 -0400
Date: Sat, 12 Jul 2008 18:53:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] regulator: TI bq24022 Li-Ion Charger driver
Message-Id: <20080712185302.05382dac.akpm@linux-foundation.org>
In-Reply-To: <1215790087.16329.6.camel@localhost.localdomain>
References: <1215790087.16329.6.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 17:28:06 +0200 Philipp Zabel <philipp.zabel@gmail.com> wrote:

> This adds a regulator driver for the TI bq24022 Single-Chip
> Li-Ion Charger with its nCE and ISET2 pins connected to GPIOs.

Incremental diffs are so much better.  It allowed us to see what you
changed.  Two things:

a) re-broke the kerneldoc comments

b) this:

--- a/drivers/regulator/bq24022.c~regulator-ti-bq24022-li-ion-charger-driver-update
+++ a/drivers/regulator/bq24022.c
@@ -145,12 +145,12 @@ static struct platform_driver bq24022_dr
 	.remove = __devexit_p(bq24022_remove),
 };
 
-static int __init bq24022_init()
+static int __init bq24022_init(void)
 {
-	platform_driver_probe(&bq24022_driver, bq24022_probe);
+	return platform_driver_probe(&bq24022_driver, bq24022_probe);
 }
 
-static void __exit bq24022_exit()
+static void __exit bq24022_exit(void)
 {
 	platform_driver_unregister(&bq24022_driver);
 }

