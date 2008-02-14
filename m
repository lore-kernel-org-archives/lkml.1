Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbYBNFQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbYBNFQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbYBNFOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:8020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYBNFOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pYYdnr40wH2l4HoJ47ErYJCYdfJLoZ21LiNzssYXTX75WlQb03DzOBtMUDM/4WG6/OA1/F9xDUO2rUz8p7DACuJV62Pz6IKTlZXFg8gPPPFMeka0i3dV3yt5t4xxMRAJak1fSh85K+ntdj5CzTRlFwdznRLKvrAMu/OcdaecYaI=
Subject: [PATCH 03/11] ata: fix sparse warning in sata_via.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:11 -0800
Message-Id: <1202966051.2748.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata/sata_via.c:336:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/sata_via.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 30caa03..0d03f44 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -333,8 +333,8 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 
 static void vt6420_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, vt6420_prereset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, vt6420_prereset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 static int vt6421_pata_cable_detect(struct ata_port *ap)
-- 
1.5.4.1.1278.gc75be


