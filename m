Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZDDEeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZDDEeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 00:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZDDEeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 00:34:10 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:41486 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZDDEeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 00:34:10 -0400
Date: Fri, 3 Apr 2009 21:31:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] regulator: fix header file missing kernel-doc
Message-Id: <20090403213130.9995f03b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49D6E309.0118:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add regulator header file missing kernel-doc:

Warning(include/linux/regulator/driver.h:117): No description found for parameter 'set_mode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc:	Liam Girdwood <lrg@slimlogic.co.uk>
cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/driver.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.29-git11.orig/include/linux/regulator/driver.h
+++ linux-2.6.29-git11/include/linux/regulator/driver.h
@@ -50,6 +50,7 @@ enum regulator_status {
  * @set_current_limit: Configure a limit for a current-limited regulator.
  * @get_current_limit: Get the configured limit for a current-limited regulator.
  *
+ * @set_mode: Set the configured operating mode for the regulator.
  * @get_mode: Get the configured operating mode for the regulator.
  * @get_status: Return actual (not as-configured) status of regulator, as a
  *	REGULATOR_STATUS value (or negative errno)
