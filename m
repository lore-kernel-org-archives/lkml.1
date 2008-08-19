Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYHSHGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYHSHGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYHSHFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:05:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45029 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYHSHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:05:51 -0400
Date: Tue, 19 Aug 2008 10:05:48 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
cc: alan@lxorguk.ukuu.org.uk
Subject: [PATCH] nubus: fix mis-indented statement
Message-ID: <Pine.LNX.4.64.0808190959040.4551@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-977394540-1219129548=:4551"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-977394540-1219129548=:4551
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


It seems this is the right way around because otherwise the
len usage in the outer loop would be pretty pointless.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/nubus/nubus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index 2f047e5..f5f7584 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -126,7 +126,7 @@ static void nubus_advance(unsigned char **ptr, int len, int map)
 	{
 		while(not_useful(p,map))
 			p++;
-			p++;
+		p++;
 		len--;
 	}
 	*ptr = p;
-- 
1.5.2.2

---696208474-977394540-1219129548=:4551--
