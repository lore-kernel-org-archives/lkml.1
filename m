Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbYKNI6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbYKNI6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYKNI6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:58:11 -0500
Received: from mail.atheros.com ([12.36.123.2]:51352 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbYKNI6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:58:10 -0500
From: <jie.yang@atheros.com>
To: <jeff@garzik.org>
CC: <pyunyh@gmail.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] atl1e:remove unnecessary crc inversion
Date: Fri, 14 Nov 2008 16:58:07 +0800
Message-ID: <12266530874043-git-send-email-jie.yang@atheros.com>
X-Mailer: git-send-email 1.5.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Yang <jie.yang@atheros.com>

remove unnecessary crc inversion.

Signed-off-by: Jie Yang <jie.yang @atheros.com>
---

diff --git a/drivers/net/atl1e/atl1e_hw.c b/drivers/net/atl1e/atl1e_hw.c
index 8cbc1b5..a2c93d1 100644
--- a/drivers/net/atl1e/atl1e_hw.c
+++ b/drivers/net/atl1e/atl1e_hw.c
@@ -174,7 +174,6 @@ u32 atl1e_hash_mc_addr(struct atl1e_hw *hw, u8 *mc_addr)
        int i;

        crc32 = ether_crc_le(6, mc_addr);
-       crc32 = ~crc32;
        for (i = 0; i < 32; i++)
                value |= (((crc32 >> i) & 1) << (31 - i));


