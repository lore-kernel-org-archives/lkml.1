Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXBECoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXBECoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXBECoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:44:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXBECoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qllSLuHRiBvJ3owyGNUNoD9ghVgKT8zbTdiGmHRCKHm0EgN+Jym5Nnl+XuNdF0XML8M6ujEDsPxaFlvOevpJvitV/RvTesfrHCxqP8LGG64blTSb3G/yovTFK7V/aPPr/lejQJ5EJx1NZw5Xhb/gazhTUa/XKPOVEKMkDiooFAU=
Date: Mon, 5 Feb 2007 04:43:57 +0200
To: spyro@f2s.com, kernel@wantstofly.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] arch ARM: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205024357.GP18118@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205023935.GG18118@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch isn't compile checked cause I have no ARM machine at hand.
Thanks,

diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index 71257e3..f1c0fb9 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -1009,7 +1009,7 @@ ecard_probe(int slot, card_type_t type)
 		ec->fiqmask = 4;
 	}
 
-	for (i = 0; i < sizeof(blacklist) / sizeof(*blacklist); i++)
+	for (i = 0; i < ARRAY_SIZE(blacklist); i++)
 		if (blacklist[i].manufacturer == ec->cid.manufacturer &&
 		    blacklist[i].product == ec->cid.product) {
 			ec->card_desc = blacklist[i].type;
diff --git a/arch/arm26/kernel/ecard.c b/arch/arm26/kernel/ecard.c
index 9dbc172..e2bcefc 100644
--- a/arch/arm26/kernel/ecard.c
+++ b/arch/arm26/kernel/ecard.c
@@ -665,7 +665,7 @@ ecard_probe(int slot, card_type_t type)
 		ec->fiqmask = 4;
 	}
 
-	for (i = 0; i < sizeof(blacklist) / sizeof(*blacklist); i++)
+	for (i = 0; i < ARRAY_SIZE(blacklist); i++)
 		if (blacklist[i].manufacturer == ec->cid.manufacturer &&
 		    blacklist[i].product == ec->cid.product) {
 			ec->card_desc = blacklist[i].type;

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
