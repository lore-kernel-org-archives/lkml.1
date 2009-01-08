Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbZAHTv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbZAHTv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZAHTvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:51:21 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:20551 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZAHTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:51:20 -0500
Date: Thu, 8 Jan 2009 11:50:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: fix kernel-doc warnings
Message-Id: <20090108115023.e0cb3115.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49665903.00C8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in regulator/driver.h:

Warning(linux-next-20090108//include/linux/regulator/driver.h:95): Excess struct/union/enum/typedef member 'set_current' description in 'regulator_ops'
Warning(linux-next-20090108//include/linux/regulator/driver.h:95): Excess struct/union/enum/typedef member 'get_current' description in 'regulator_ops'
Warning(linux-next-20090108//include/linux/regulator/driver.h:124): No description found for parameter 'irq'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Liam Girdwood <lrg@slimlogic.co.uk>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/driver.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-next-20090108.orig/include/linux/regulator/driver.h
+++ linux-next-20090108/include/linux/regulator/driver.h
@@ -29,16 +29,12 @@ struct regulator_init_data;
  *
  * @enable: Enable the regulator.
  * @disable: Disable the regulator.
- * @is_enabled: Return 1 if the reguator is enabled, 0 otherwise.
+ * @is_enabled: Return 1 if the regulator is enabled, 0 otherwise.
  *
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
  * @get_voltage: Return the currently configured voltage for the regulator.
  *
- * @set_current: Set the current for the regulator within the range specified.
- *               The driver should select the current closest to min_uA.
- * @get_current: Return the currently configured current for the regulator.
- *
  * @set_current_limit: Configure a limit for a current-limited regulator.
  * @get_current_limit: Get the limit for a current-limited regulator.
  *
@@ -111,6 +107,7 @@ enum regulator_type {
  * @name: Identifying name for the regulator.
  * @id: Numerical identifier for the regulator.
  * @ops: Regulator operations table.
+ * @irq: Interrupt number for the regulator.
  * @type: Indicates if the regulator is a voltage or current regulator.
  * @owner: Module providing the regulator, used for refcounting.
  */
