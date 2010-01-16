Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901Ab0APWwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0APWwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770Ab0APWwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:52:30 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:56445 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0APWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GfUEyWxt+CnfHaRG+sYxYp83GtNILkOo5s3nNHM+xikfZ+iJMxhGxmHoV+sCaN+qa+
         BC6WoG+bOhaevAjkJPKxBildTwblGDEjwY/lKMnR0rsPZ/Esdk1CecvfoiuX8CIHUwrZ
         rqZ9hlGsHqwDRJpfzcK/gBlE8ZGNrPYyoybjE=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Uwe Geuder <ubuntuLp-ugeuder@sneakemail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] console/vgacon.c: mark file-local symbol static.
Date: Sat, 16 Jan 2010 17:52:13 -0500
Message-Id: <1c1713c0724e7a7283fce34b0d23a2eaa929df10.1263682176.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.103.g699d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: symbol 'vgacon_text_mode_force' was not declared. Should it be static?

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/video/console/vgacon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index cc4bbbe..19e474d 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -112,7 +112,7 @@ static int 		vga_video_font_height;
 static int 		vga_scan_lines		__read_mostly;
 static unsigned int 	vga_rolled_over;
 
-int vgacon_text_mode_force = 0;
+static int vgacon_text_mode_force = 0;
 
 bool vgacon_text_force(void)
 {
-- 
1.6.6.103.g699d2

