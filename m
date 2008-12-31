Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYLaRt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYLaRt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYLaRtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:49:19 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:19344 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbYLaRtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:49:18 -0500
Date: Wed, 31 Dec 2008 09:48:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] dmi: fix kernel-doc notation
Message-Id: <20081231094808.1b825426.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.495BB05B.00B1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc notation:

drivers/firmware/dmi_scan.c:475: No description found for parameter 'str'
drivers/firmware/dmi_scan.c:592: No description found for parameter 'f'
drivers/firmware/dmi_scan.c:592: No description found for parameter 'str'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/firmware/dmi_scan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.28-git3.orig/drivers/firmware/dmi_scan.c
+++ linux-2.6.28-git3/drivers/firmware/dmi_scan.c
@@ -468,8 +468,8 @@ const char *dmi_get_system_info(int fiel
 EXPORT_SYMBOL(dmi_get_system_info);
 
 /**
- *	dmi_name_in_serial - 	Check if string is in the DMI product serial
- *				information.
+ * dmi_name_in_serial - Check if string is in the DMI product serial information
+ * @str: string to check for
  */
 int dmi_name_in_serial(const char *str)
 {
@@ -585,6 +585,8 @@ EXPORT_SYMBOL_GPL(dmi_walk);
 
 /**
  * dmi_match - compare a string to the dmi field (if exists)
+ * @f: DMI field identifier
+ * @str: string to compare the DMI field to
  *
  * Returns true if the requested field equals to the str (including NULL).
  */
