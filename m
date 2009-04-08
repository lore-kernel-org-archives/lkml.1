Return-Path: <linux-kernel-owner+w=401wt.eu-S1764146AbZDHLYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764146AbZDHLYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762646AbZDHLWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39607 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757789AbZDHLWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:37 -0400
X-Sasl-enc: lce02/YC7OkcjcevMfDsTpEzH19DfB498NZgCHtvMfAn 1239189755
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 03/56] atm: Remove void casts
Date: Wed,  8 Apr 2009 12:21:35 +0100
Message-Id: <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/atm/lanai.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index cf97c34..2c9d0da 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1459,7 +1459,7 @@ static int __devinit vcc_table_allocate(struct lanai_dev *lanai)
 	return (lanai->vccs == NULL) ? -ENOMEM : 0;
 #else
 	int bytes = (lanai->num_vci) * sizeof(struct lanai_vcc *);
-	lanai->vccs = (struct lanai_vcc **) vmalloc(bytes);
+	lanai->vccs = vmalloc(bytes);
 	if (unlikely(lanai->vccs == NULL))
 		return -ENOMEM;
 	memset(lanai->vccs, 0, bytes);
-- 
1.5.4.3

