Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbZGABV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbZGABV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765526AbZGABEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:20 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59235 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765518AbZGABES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:18 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: [PATCH 2/6] tpm_tis: add MODULE_DEVICE_TABLE to enable autoload
Date: Tue, 30 Jun 2009 18:04:11 -0700
Message-Id: <1246410255-6839-3-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246410255-6839-1-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Isaacson <adi@vmware.com>
---
 drivers/char/tpm/tpm_tis.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 1b84441..e859e0e 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -629,6 +629,7 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
 };
+MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 
 static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
-- 
1.6.3.1

