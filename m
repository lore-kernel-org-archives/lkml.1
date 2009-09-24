Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZIXT2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZIXT2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZIXT2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:28:32 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:52458 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZIXT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:27:59 -0400
Subject: [PATCH] TPM: increase default TPM buffer
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmorris@namei.org
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:27:46 -0300
Message-Id: <1253820466.8653.9.camel@dyn531367.br.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPM Working Group requested this communication buffer increase given that a
particular TPM vendor can support a TPM_SHA1Start command input bigger than the
current size.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index b0603b2..f4c68ab 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -31,7 +31,7 @@
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 2048,
+	TPM_BUFSIZE = 4096,
 	TPM_NUM_DEVICES = 256,
 };
 
-- 
1.6.3.1



