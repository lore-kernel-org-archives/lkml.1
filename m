Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYJ3K6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYJ3K6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYJ3K6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:58:44 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38352 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYJ3K6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:58:43 -0400
Date: Thu, 30 Oct 2008 12:58:38 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: James.Bottomley@HansenPartnership.com
cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Nick Warne <nick@ukfsn.org>
Subject: [PATCH] scsi/tmscsim: fix indentation and braces disagreement - add
 braces
Message-ID: <Pine.LNX.4.64.0810301257110.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-664936530-1225364318=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-664936530-1225364318=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Lucky winner is 557cc476c04 ([SCSI] tmscsim: Fixup
KERN_INFO in printk).

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Nick Warne <nick@ukfsn.org>
---
 drivers/scsi/tmscsim.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 69ac6e5..9a42734 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2572,9 +2572,10 @@ static struct pci_driver dc390_driver = {
 
 static int __init dc390_module_init(void)
 {
-	if (!disable_clustering)
+	if (!disable_clustering) {
 		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
 		printk(KERN_INFO "       with \"disable_clustering=1\" and report to maintainers\n");
+	}
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;
-- 
1.5.2.2

---696208474-664936530-1225364318=:7072--
