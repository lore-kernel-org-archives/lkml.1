Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYACV65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYACV65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYACV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:58:32 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11149 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752567AbYACV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:58:30 -0500
Date: Thu, 03 Jan 2008 14:30:20 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/4] drivers-edac-mpc85xx-add-static-scope
Message-ID: <477d53ec.JGciTud4aj4R7yU2%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Made a previous global variable, static in scope

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 mpc85xx_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23.8/drivers/edac/mpc85xx_edac.c
===================================================================
--- linux-2.6.23.8.orig/drivers/edac/mpc85xx_edac.c
+++ linux-2.6.23.8/drivers/edac/mpc85xx_edac.c
@@ -43,7 +43,7 @@ static u32 orig_pci_err_en;
 static u32 orig_l2_err_disable;
 static u32 orig_hid1;
 
-const char *mpc85xx_ctl_name = "MPC85xx";
+static const char *mpc85xx_ctl_name = "MPC85xx";
 
 /************************ MC SYSFS parts ***********************************/
 
