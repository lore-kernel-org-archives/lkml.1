Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbZEFCN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbZEFCN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZEFCNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:13:46 -0400
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:53807 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZEFCNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:13:45 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>
Date: Tue, 5 May 2009 20:12:57 -0600
Subject: [PATCH 10/10] scsi: megaraid_sas - Version and Documentation update
Thread-Topic: [PATCH 10/10] scsi: megaraid_sas - Version and Documentation
 update
Thread-Index: AciIcSnS7H5xFQtCQzyNHR19nlBrTUImYsQgDzPsVNAAASQyUAAAt2hQAAD+YdAAAIJO4AAAleYAAAA/NeAAADscYAAAgg+gAABg/iA=
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C6C@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C69@cosmail02.lsi.com>
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

Driver Version and Documentation Update

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
 3 files changed, 34 insertions(+), 4 deletions(-)

diff -rupN linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas 2009-05-04 20:00:32.000000000 -0400
+++ linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas  2009-05-04 20:00:32.000000000 -0400
@@ -1,4 +1,34 @@

+1 Release Date    : Tues. Feb. 10, 2009 10:12:45 PST 2009 -
+                        (emaild-id:megaraidlinux@lsi.com)
+                        Bo Yang
+
+2 Current Version : 00.00.04.08
+3 Older Version   : 00.00.04.01
+
+1.     Add the Tape drive fix to the driver: If the command is for the tape
+               device, set the pthru timeout to the os layer timeout value.
+
+2.     Add Poll_wait mechanism to Gen-2 Linux driv.
+               In the aen handler, driver needs to wakeup poll handler
+               similar to the way it raises SIGIO. Driver needs to reregister
+               for AEN with the FW when it receives AEN. This will ensure AEN
+               continuity and avoid depending upon storelib to continue events.
+
+3.     Add new controller 0x73(new SAS2) support to the driver.
+
+4.     Report the unconfigured PD (system PD) to OS.
+
+5.     Add the IEEE SGL support to the driver
+
+6.     Reasign the Application cmds to 0x73 controller
+
+7.     Fixed the two AEN cmds pending in FW.
+
+8.     Fixed the logic drive deleted and pemding cmds pending in fw issue.
+
+9.     Fixed the driver load and unload issue.
+
 1 Release Date    : Thur.July. 24 11:41:51 PST 2008 -
                        (emaild-id:megaraidlinux@lsi.com)
                        Sumant Patro
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 23:04:47.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 23:05:23.000000000 -0400
@@ -10,7 +10,7 @@
  *        2 of the License, or (at your option) any later version.
  *
  * FILE                : megaraid_sas.c
- * Version     : v00.00.04.01-rc1
+ * Version     : v00.00.04.08-rc1
  *
  * Authors:
  *     (email-id : megaraidlinux@lsi.com)
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-05-04 20:48:19.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-05-04 20:00:32.000000000 -0400
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION                                "00.00.04.01"
-#define MEGASAS_RELDATE                                "July 24, 2008"
-#define MEGASAS_EXT_VERSION                    "Thu July 24 11:41:51 PST 2008"
+#define MEGASAS_VERSION                                "00.00.04.08-RC1"
+#define MEGASAS_RELDATE                                "May 05, 2009"
+#define MEGASAS_EXT_VERSION                    "Tues May 05, 11:41:51 PST 2008"

 /*
  * Device IDs
