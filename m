Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbZAUA3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbZAUA3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbZAUA3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:29:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:38901 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202AbZAUA3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:29:32 -0500
Date: Tue, 20 Jan 2009 16:29:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] regulator: fix header file missing kernel-doc
Message-Id: <20090120162905.62e2228c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49766C62.0277:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix regulator/driver.h missing kernel-doc:

Warning(linux-next-20090120//include/linux/regulator/driver.h:108): No description found for parameter 'get_status'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Liam Girdwood <lrg@slimlogic.co.uk>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/driver.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090120.orig/include/linux/regulator/driver.h
+++ linux-next-20090120/include/linux/regulator/driver.h
@@ -51,6 +51,7 @@ enum regulator_status {
  *
  * @set_mode: Set the operating mode for the regulator.
  * @get_mode: Get the current operating mode for the regulator.
+ * @get_status: Report the regulator status.
  * @get_optimum_mode: Get the most efficient operating mode for the regulator
  *                    when running with the specified parameters.
  *
