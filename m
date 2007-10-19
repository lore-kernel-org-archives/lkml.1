Return-Path: <linux-kernel-owner+w=401wt.eu-S936593AbXJSTu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936593AbXJSTu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935276AbXJSTuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:50:01 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24614 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764038AbXJSTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:49:59 -0400
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 15:49:59 EDT
Date: Fri, 19 Oct 2007 13:16:43 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/8] drivers-edac-turnon edac device error logging
Message-ID: <4719029b.yLjfdGUW2HMOjG56%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This patch ENABLES the 'logging' of CE and UE events for the 
EDAC_DEVICE class of error harvester in EDAC

CC:	Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---

 edac_device.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.23/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.23.orig/drivers/edac/edac_device.c
+++ linux-2.6.23/drivers/edac/edac_device.c
@@ -155,6 +155,10 @@ struct edac_device_ctl_info *edac_device
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
 
+	/* Default logging of CEs and UEs */
+	dev_ctl->log_ce = 1;
+	dev_ctl->log_ue = 1;
+
 	/* Name of this edac device */
 	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s",edac_device_name);
 
