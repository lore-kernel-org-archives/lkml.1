Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270Ab0AQNgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0AQNgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 08:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985Ab0AQNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 08:36:45 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:49691 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQNgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 08:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lTm3iEEyStMb5keuFXV6HoE/FHkUPnF5oWKlmoSCCuJqkbnnhSTinsDbApQ+6i3VBQ
         Uuoy6Ou3enhWN5SutQsYz/Otqm5Fi8+lTR4uZlNaP6P3LXjeU+uMggASmv7KjJ8DKJov
         z6V2DCcUKIY5GLBofkm9curphm8/oBCMY07aU=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Uwe Geuder <ubuntuLp-ugeuder@sneakemail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] console/vgacon.c: mark file-local symbol static.
Date: Sun, 17 Jan 2010 08:36:36 -0500
Message-Id: <b860e7b14e77736d612a679b7a8fdd36ae76d24b.1263734945.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.103.g699d2
In-Reply-To: <20100117011822.GA6272@srcf.ucam.org>
References: <20100117011822.GA6272@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: symbol 'vgacon_text_mode_force' was not declared. Should it be static?

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/video/console/vgacon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index cc4bbbe..182dd6f 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -112,7 +112,7 @@ static int 		vga_video_font_height;
 static int 		vga_scan_lines		__read_mostly;
 static unsigned int 	vga_rolled_over;
 
-int vgacon_text_mode_force = 0;
+static int vgacon_text_mode_force;
 
 bool vgacon_text_force(void)
 {
-- 
1.6.6.103.g699d2

