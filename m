Return-Path: <linux-kernel-owner+w=401wt.eu-S1765284AbYHEUVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765284AbYHEUVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbYHEUP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:15:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43853 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764075AbYHEUPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:15:55 -0400
Date: Tue, 5 Aug 2008 23:14:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Konrad Rzeszutek <ketuzsezr@darnok.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] drivers/firmware/iscsi_ibft.c: make 3 functions static
Message-ID: <20080805201427.GK22895@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- ibft_attr_show_initiator()
- ibft_attr_show_nic()
- ibft_attr_show_target()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 23 Apr 2008

 drivers/firmware/iscsi_ibft.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

421adc9620a633d461059da9a8a94315d8a767ea diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 8024e3b..8523811 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -334,9 +334,9 @@ static void ibft_release(struct kobject *kobj)
 /*
  *  Routines for parsing the iBFT data to be human readable.
  */
-ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
-				  struct ibft_attribute *attr,
-				  char *buf)
+static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
+					struct ibft_attribute *attr,
+					char *buf)
 {
 	struct ibft_initiator *initiator = entry->initiator;
 	void *ibft_loc = entry->header;
@@ -376,9 +376,9 @@ ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
 	return str - buf;
 }
 
-ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
-			    struct ibft_attribute *attr,
-			    char *buf)
+static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
+				  struct ibft_attribute *attr,
+				  char *buf)
 {
 	struct ibft_nic *nic = entry->nic;
 	void *ibft_loc = entry->header;
@@ -440,9 +440,9 @@ ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
 	return str - buf;
 };
 
-ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
-			       struct ibft_attribute *attr,
-			       char *buf)
+static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
+				     struct ibft_attribute *attr,
+				     char *buf)
 {
 	struct ibft_tgt *tgt = entry->tgt;
 	void *ibft_loc = entry->header;

