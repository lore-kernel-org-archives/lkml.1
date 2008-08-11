Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYHKS75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYHKS75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYHKS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:59:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35604 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYHKS7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:59:46 -0400
Subject: [2.6 patch make struct scsi_dh_devlist's static
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
X-Sieve: CMU Sieve 2.3
X-Xagent-From: bunk@kernel.org
X-Xagent-To: sekharan@linux.vnet.ibm.com
X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGENTU2 at VMSDVMA)
X-Xagent-From: sekharan@us.ibm.com
X-Xagent-To: sekharan@linux.vnet.ibm.com
X-Xagent-Gateway: vmsdvma.vnet.ibm.com (XAGENTU at VMSDVMA)
Content-Type: text/plain
Organization: IBM
Date: Mon, 11 Aug 2008 11:59:21 -0700
Message-Id: <1218481161.16794.10.camel@chandra-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch makes several needlessly global struct scsi_dh_devlist's 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---

 drivers/scsi/device_handler/scsi_dh_alua.c  |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

ae6ee914615e415cc4b22ee1c0545bb088889b6a 
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fcdd73f..994da56 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -680,7 +680,7 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)

 }

-const struct scsi_dh_devlist alua_dev_list[] = {
+static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"HP", "MSA VOLUME" },
 	{"HP", "HSV101" },
 	{"HP", "HSV111" },
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index aa46b13..b9d23e9 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -562,7 +562,7 @@ done:
 	return result;
 }

-const struct scsi_dh_devlist clariion_dev_list[] = {
+static const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
 	{"DGC", "VRAID"},
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9c7a1f8..a6a4ef3 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -282,7 +282,7 @@ static int hp_sw_activate(struct scsi_device *sdev)
 	return ret;
 }

-const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
+static const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
 	{"COMPAQ", "MSA1000 VOLUME"},
 	{"COMPAQ", "HSV110"},
 	{"HP", "HSV100"},
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..e7c7b4e 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -574,7 +574,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }

-const struct scsi_dh_devlist rdac_dev_list[] = {
+static const struct scsi_dh_devlist rdac_dev_list[] = {
 	{"IBM", "1722"},
 	{"IBM", "1724"},
 	{"IBM", "1726"},



