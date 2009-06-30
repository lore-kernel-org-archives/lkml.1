Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbZF3Vtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbZF3Vtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZF3Vts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:49:48 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:58456 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZF3Vtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:49:47 -0400
Date: Tue, 30 Jun 2009 14:49:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] hwmon: fix lis3-spi for CONFIG_PM=n
Message-Id: <20090630144937.055280ca.randy.dunlap@oracle.com>
In-Reply-To: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A4A8873.00BA:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_PM=n:

The suspend & resume function names are incorrect for the
PM=n case.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/hwmon/lis3lv02d_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2009-0630-1250.orig/drivers/hwmon/lis3lv02d_spi.c
+++ mmotm-2009-0630-1250/drivers/hwmon/lis3lv02d_spi.c
@@ -108,8 +108,8 @@ static int lis3lv02d_spi_resume(struct s
 }
 
 #else
-#define lis3_spi_suspend	NULL
-#define lis3_spi_resume		NULL
+#define lis3lv02d_spi_suspend	NULL
+#define lis3lv02d_spi_resume	NULL
 #endif
 
 static struct spi_driver lis302dl_spi_driver = {


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
