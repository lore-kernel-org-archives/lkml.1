Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979Ab0ARX56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0ARX56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 18:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728Ab0ARX55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 18:57:57 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:64114 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0ARX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 18:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gNQvn4C7TxOuMa/Sxm460MoIALChTArzdrL+TMFx91tIsavHYWWfmMo+NhMX4u5e85
         +T3NAvbXDEpystCCXkRU55r7Mt7AzONib+fC0ZDVV7fbcYVngeNVwu1D+vd2uXBUP1OD
         pqIENbqsCnvaiL3MaeairfVYemBHyUgJI6UAA=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] lib/dma-debug.c: mark file-local struct symbol static.
Date: Mon, 18 Jan 2010 18:57:33 -0500
Message-Id: <d9a890882c693c1e1d046e034fb8cfb130eafe31.1263858860.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.201.g56119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: symbol 'filter_fops' was not declared. Should it be static?

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 lib/dma-debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 7d2f0b3..ba8b670 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -587,7 +587,7 @@ out_unlock:
 	return count;
 }
 
-const struct file_operations filter_fops = {
+static const struct file_operations filter_fops = {
 	.read  = filter_read,
 	.write = filter_write,
 };
-- 
1.6.6.201.g56119

