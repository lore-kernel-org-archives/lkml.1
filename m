Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYJ3LLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYJ3LLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYJ3LLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:11:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42594 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYJ3LLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:11:30 -0400
Date: Thu, 30 Oct 2008 13:11:29 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/10] consolemap: indentation & braces disagree - reindent
In-Reply-To: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810301310400.7072@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1577895564-1225365089=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1577895564-1225365089=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


I hope I got this one correctly.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/char/consolemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/consolemap.c b/drivers/char/consolemap.c
index 4246b8e..45d3e80 100644
--- a/drivers/char/consolemap.c
+++ b/drivers/char/consolemap.c
@@ -554,7 +554,7 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struct unipair __user *list)
 		__get_user(fontpos, &list->fontpos);
 		if ((err1 = con_insert_unipair(p, unicode,fontpos)) != 0)
 			err = err1;
-			list++;
+		list++;
 	}
 	
 	if (con_unify_unimap(vc, p))
-- 
1.5.2.2

---696208474-1577895564-1225365089=:7072--
