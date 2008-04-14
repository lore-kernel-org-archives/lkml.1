Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYDNWuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYDNWuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYDNWsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:48:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:34443 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761303AbYDNWsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hl2rmLNFIwpJvFF6b+G5HyhQRpK57V7t3A10UJaXizXaj+sAzPv/70x0q20Lp/Jel7Kcm+OtWXNfsBWDMc3cVdAJJtUkU9HdHTTGF0mJI3EhgjELjiDOUj8q0hcn3/oTiSEOAkZvmvADCDevjkXqibfRyyzw6tirUGmw47OXAcQ=
Subject: [PATCH-mm 06/15] mmc: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:47:58 -0700
Message-Id: <1208213278.11920.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/mmc/host/mmc_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 365024b..3550858 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -340,7 +340,7 @@ checkstatus:
 
 	/* SPI R3, R4, or R7 == R1 + 4 bytes */
 	case MMC_RSP_SPI_R3:
-		cmd->resp[1] = be32_to_cpu(get_unaligned((u32 *)cp));
+		cmd->resp[1] = get_unaligned_be32(cp);
 		break;
 
 	/* SPI R1 == just one status byte */
-- 
1.5.5.144.g3e42


