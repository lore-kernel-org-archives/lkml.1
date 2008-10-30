Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbYJ3LfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbYJ3LfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYJ3Lex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:34:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39444 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYJ3Lew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:34:52 -0400
Date: Thu, 30 Oct 2008 13:34:45 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: kkeil@suse.de
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/10] misdn: one handmade ARRAY_SIZE converted
In-Reply-To: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810301332590.7072@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1397956341-1225366485=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1397956341-1225366485=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Defined as:

static struct device_attribute element_attributes[] = {

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/isdn/mISDN/dsp_pipeline.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 850260a..45bff0a 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -99,8 +99,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 		goto err1;
 	}
 
-	for (i = 0; i < (sizeof(element_attributes)
-		/ sizeof(struct device_attribute)); ++i)
+	for (i = 0; i < ARRAY_SIZE(element_attributes); ++i)
 		ret = device_create_file(&entry->dev,
 				&element_attributes[i]);
 		if (ret) {
-- 
1.5.2.2

---696208474-1397956341-1225366485=:7072--
