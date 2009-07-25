Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbZGYRoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbZGYRoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZGYRoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:44:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:36958 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751107AbZGYRoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:44:37 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+ga0IKM4mgf5i7nJkIqmZV8SU0/3KjMmLoIq9m8b
	9bDEJXbXMHeZ8b
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] remove needless variable from drivers/video/fbmon.c
Date: Sat, 25 Jul 2009 19:44:34 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907251944.35148.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbmon.c: integer err is not needed

Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
---
 drivers/video/fbmon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 9ae9cd3..e1b7073 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -277,17 +277,17 @@ static int edid_checksum(unsigned char *edid)

 static int edid_check_header(unsigned char *edid)
 {
-       int i, err = 1, fix = check_edid(edid);
+       int i, fix = check_edid(edid);

        if (fix)
                fix_edid(edid, fix);

        for (i = 0; i < 8; i++) {
                if (edid[i] != edid_v1_header[i])
-                       err = 0;
+                       return 0;
        }

-       return err;
+       return 1;
 }

 static void parse_vendor_block(unsigned char *block, struct fb_monspecs *specs)
-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

