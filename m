Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbZBEQzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbZBEQzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZBEQyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:54:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:24489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbZBEQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:54:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h22sU8KN+Eum4XI81mATo+ghZcIdtimppR3ixaai12qeuGozbBV7UR9A5xpZYRhefP
         gDb1t2k6HzBt++rbXZhQtDf2nulBofW4BI39ZmSHFGsFpg8WHoLBHGfO4Mj9uRbwxVDZ
         czhqUtMZGM/8CcRCPwdyZTEpc66mgPJgLFz2I=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 4/6] mfd: PASIC3: remove unused bus_shift field
Date: Thu,  5 Feb 2009 17:53:38 +0100
Message-Id: <1233852820-28549-5-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the now-unused bus_shift field from pasic3_platform_data.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/mfd/htc-pasic3.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/htc-pasic3.h b/include/linux/mfd/htc-pasic3.h
index b4294f1..3d3ed67 100644
--- a/include/linux/mfd/htc-pasic3.h
+++ b/include/linux/mfd/htc-pasic3.h
@@ -48,7 +48,6 @@ struct pasic3_leds_machinfo {
 
 struct pasic3_platform_data {
 	struct pasic3_leds_machinfo *led_pdata;
-	unsigned int                 bus_shift;
 	unsigned int                 clock_rate;
 };
 
-- 
1.5.6.5

