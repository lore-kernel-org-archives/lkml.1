Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbZDLKsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbZDLKsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbZDLKrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:47:37 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49842 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598AbZDLKrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:47:35 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 4/4] balance parenthesis in sis init301.c code
Date: Sun, 12 Apr 2009 12:47:31 +0200
Message-Id: <1239533251-31276-5-git-send-email-m.kozlowski@tuxland.pl>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
References: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's under #ifdef 0 but I think it's worth fixing anyway.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
---
 drivers/video/sis/init301.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index da33d80..4b61e1b 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -11017,7 +11017,7 @@ SetOEMLCDData(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
   unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
   unsigned short index,temp;
 
-  if((SiS_Pr->SiS_UseROM) {
+  if (SiS_Pr->SiS_UseROM) {
      if(!(ROMAddr[0x237] & 0x01)) return;
      if(!(ROMAddr[0x237] & 0x04)) return;
      /* No rom pointer in BIOS header! */
-- 
1.5.6.3

