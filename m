Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbXHAKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbXHAKt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXHAKtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:49:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:53933 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbXHAKtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=XAKDDZseYbeq1yEbuEXBIXBzKO1fL+kGgAOL3EB1h9080pn3anL6z3pYGw8K06gQOogCrErBpjqSB2xQTdGx90x5t8pjz4I4KZa7HCrouPvdfLEDUyeIt6UgIIIi/3aw9hgIxDmKhC5SxZpJEJv0U5U1ARD9OMjkkB1lI8nqvho=
Date: Wed, 1 Aug 2007 18:48:31 +0800
To: linux-kernel@vger.kernel.org
Cc: info-linux@geode.amd.com
Subject: [PATCH] drivers/video/geode/lxfb_core.c: fix lxfb_setup warning
Message-ID: <20070801104831.GA16362@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning:

drivers/video/geode/lxfb_core.c: In function 'lxfb_setup':
drivers/video/geode/lxfb_core.c:564: warning: unused variable 'opt'

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/video/geode/lxfb_core.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 5e30b40..255c8b3 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -566,12 +566,7 @@ static int __init lxfb_setup(char *options)
 	if (!options || !*options)
 		return 0;
 
-	while (1) {
-		char *opt = strsep(&options, ",");
-
-		if (opt == NULL)
-			break;
-
+	while ( (opt = strsep(&options, ",")) != NULL) {
 		if (!*opt)
 			continue;
 

