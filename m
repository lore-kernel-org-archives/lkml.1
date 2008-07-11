Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYGKTR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYGKTR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbYGKTRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:17:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759AbYGKTRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:17:13 -0400
Date: Fri, 11 Jul 2008 12:16:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] regulator: TI bq24022 Li-Ion Charger driver
Message-Id: <20080711121638.3710c1ad.akpm@linux-foundation.org>
In-Reply-To: <1215716683.17490.29.camel@localhost.localdomain>
References: <1215716683.17490.29.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 21:04:43 +0200 Philipp Zabel <philipp.zabel@gmail.com> wrote:

> +/**
> + *bq24022_mach_info - platform data for bq24022
> + *@gpio_nce: GPIO line connected to the nCE pin,
> + *           used to enable / disable charging.
> + *@gpio_iset2: GPIO line connected to the ISET2 pin,
> + *             used to limit charging current to 100 mA / 500 mA.
> + */

We normally have a space after the "*" in kerneldoc comments (some
weird people use a tab and waste space).

I don't know whether the kerneldoc processors will correctly handle
the above.  I guess I'll fix it so we don't find out.

Also, I _think_ that kerneldoc will barf over the multi-line parameter
descriptions.  I'll join those lines.

--- a/include/linux/regulator/bq24022.h~regulator-ti-bq24022-li-ion-charger-driver-fix
+++ a/include/linux/regulator/bq24022.h
@@ -11,11 +11,9 @@
  */
 
 /**
- *bq24022_mach_info - platform data for bq24022
- *@gpio_nce: GPIO line connected to the nCE pin,
- *           used to enable / disable charging.
- *@gpio_iset2: GPIO line connected to the ISET2 pin,
- *             used to limit charging current to 100 mA / 500 mA.
+ * bq24022_mach_info - platform data for bq24022
+ * @gpio_nce: GPIO line connected to the nCE pin, used to enable / disable charging
+ * @gpio_iset2: GPIO line connected to the ISET2 pin, used to limit charging current to 100 mA / 500 mA
  */
 struct bq24022_mach_info {
 	int gpio_nce;
_

