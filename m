Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbYLMXCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbYLMXCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYLMXBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:01:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:55139 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYLMXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RvKQ7ifvYw6i8smEQ4FaFk5AWzwpOtwC0g9aRtGX1hziDX5jIymJ2w7Vxx8k+r6MjR
         IzcTxEAJT6M/Pz6p+TaNYxs33ZYtyg5CzNr1hSRJdHxR3jJI7SlcUoT3dUlNkJZXrhl8
         r6/Hz219a4ud5tjBpouXnawlcrVk44kKvt4e0=
Subject: [PATCH 1/4] pcilynx: trivial endian annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:01:50 -0800
Message-Id: <1229209311.11257.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bus_info_block was treated as a be32 everywhere, annotate
as such.  Removes plenty of sparse warnings.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Hi Stefan, should be no funcitonal changes in this batch, just
breaking up the sparse fixes in to more digestible chunks.

 drivers/ieee1394/pcilynx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee1394/pcilynx.h b/drivers/ieee1394/pcilynx.h
index ec27321..693a169 100644
--- a/drivers/ieee1394/pcilynx.h
+++ b/drivers/ieee1394/pcilynx.h
@@ -52,7 +52,7 @@ struct ti_lynx {
         void __iomem *local_rom;
         void __iomem *local_ram;
         void __iomem *aux_port;
-	quadlet_t bus_info_block[5];
+	__be32 bus_info_block[5];
 
         /*
          * use local RAM of LOCALRAM_SIZE bytes for PCLs, which allows for
-- 
1.6.1.rc2.306.ge5d5e


