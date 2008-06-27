Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbYF0S0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbYF0S0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759891AbYF0SZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:25:51 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11698 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757392AbYF0SZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:25:49 -0400
Date: Fri, 27 Jun 2008 12:13:48 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 12/13] EDAC mv64x60 fix get_property
Message-ID: <48652ddc.OYdNIxyJzxlkvSnp%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update get_property() call to use of_get_property() in order to fix compile

Signed-off-by: Dave Jiang <djiang@mvista.com>

Index: 2.6.26-rc5-mm3/drivers/edac/mv64x60_edac.c
===================================================================
--- 2.6.26-rc5-mm3.orig/drivers/edac/mv64x60_edac.c
+++ 2.6.26-rc5-mm3/drivers/edac/mv64x60_edac.c
@@ -612,7 +612,7 @@ static void get_total_mem(struct mv64x60
 	if (!np)
 		return;
 
-	reg = get_property(np, "reg", NULL);
+	reg = of_get_property(np, "reg", NULL);
 
 	pdata->total_mem = reg[1];
 }
