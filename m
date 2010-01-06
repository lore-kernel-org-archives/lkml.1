Return-Path: <linux-kernel-owner+w=401wt.eu-S932962Ab0AFW6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab0AFW6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865Ab0AFW6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:58:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48498 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab0AFW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BwAViYlS9HcQxIEbccSCny+KvOUaMsdUtePFf/RbYwzYUOa1cDDoJrIU64/GE1LOT9
         rDRpSYa0YDq+mMmJWK9YGxE5Fgtq1eAloKUe7tvJ/wv0rOyJwU8lVG5HNgtqhOjXhWBV
         UL5YkxKDehRk3Gqn3xBXbbSQ89frPrLJWh6yk=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: pma@mediamatech.com, haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] avr32: MRMT: remove unneeded bracket
Date: Thu,  7 Jan 2010 01:58:00 +0300
Message-Id: <1262818680-20412-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should cause a build error.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 arch/avr32/boards/atngw100/mrmt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
index 7919be3..390223f 100644
--- a/arch/avr32/boards/atngw100/mrmt.c
+++ b/arch/avr32/boards/atngw100/mrmt.c
@@ -150,7 +150,6 @@ static struct ac97c_platform_data __initdata ac97c0_data = {
 static struct platform_device rmt_ts_device = {
 	.name	= "ucb1400_ts",
 	.id	= -1,
-	}
 };
 #endif
 
-- 
1.6.6

