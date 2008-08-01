Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbYHAV2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbYHAV2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbYHAV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:26:05 -0400
Received: from mail0.lsil.com ([147.145.40.20]:38149 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759934AbYHAV0C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:26:02 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Patro, Sumant" <Sumant.Patro@lsi.com>,
       "poswald@novell.com" <poswald@novell.com>,
       "Austria, Winston" <Winston.Austria@lsi.com>
Date: Fri, 1 Aug 2008 15:25:06 -0600
Subject: [PATCH 4/4] scsi: megaraid_sas - Version and Documentation Update
Thread-Topic: [PATCH 4/4] scsi: megaraid_sas - Version and Documentation
 Update
Thread-Index: AciItAVU2/gnyqciSguN4aHHEiVCxRrPlpmwAAF0YNAACRk1MA==
Message-ID: <4B6A08C587958942AA3002690DD4F8C31B080A6F@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C31B080A66@cosmail02.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the Version and Documentation.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 Documentation/scsi/ChangeLog.megaraid_sas |   23 +++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff -rupN linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas 2008-07-31 13:34:16.000000000 -0400
+++ linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas  2008-07-31 14:18:36.000000000 -0400
@@ -1,3 +1,26 @@
+
+1 Release Date    : Thur.July. 24 11:41:51 PST 2008 -
+                       (emaild-id:megaraidlinux@lsi.com)
+                       Sumant Patro
+                       Bo Yang
+
+2 Current Version : 00.00.04.01
+3 Older Version   : 00.00.03.22
+
+1. Add the new controller (0078, 0079) support to the driver
+       Those controllers are LSI's next generatation(gen2) SAS controllers.
+
+1 Release Date    : Mon.June. 23 10:12:45 PST 2008 -
+                       (emaild-id:megaraidlinux@lsi.com)
+                       Sumant Patro
+                       Bo Yang
+
+2 Current Version : 00.00.03.22
+3 Older Version   : 00.00.03.20
+
+1. Add shutdown DCMD cmd to the shutdown routine to make FW shutdown proper.
+2. Unexpected interrupt occurs in HWR Linux driver, add the dumy readl pci flush will fix this issue.
+
 1 Release Date    : Mon. March 10 11:02:31 PDT 2008 -
                        (emaild-id:megaraidlinux@lsi.com)
                        Sumant Patro
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2008-07-31 13:34:16.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2008-07-31 13:41:56.000000000 -0400
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION                        "00.00.03.20-rc1"
-#define MEGASAS_RELDATE                        "March 10, 2008"
-#define MEGASAS_EXT_VERSION            "Mon. March 10 11:02:31 PDT 2008"
+#define MEGASAS_VERSION                                "00.00.04.01"
+#define MEGASAS_RELDATE                                "July 24, 2008"
+#define MEGASAS_EXT_VERSION                    "Thu July 24 11:41:51 PST 2008"

 /*
  * Device IDs
