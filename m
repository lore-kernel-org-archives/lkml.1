Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515Ab0ATL7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0ATL7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416Ab0ATL7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:59:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:58559 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0ATL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:59:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=bT8VTmtPbHlkFDGWfHliUQgSx2Y3Vdvc+QteWsuHhARhsojUoNXmI8xGGLf1E6zoRj
         G3WY9UmX1+p/dfas5pewf+WB3DDa0NaVwQc7SP9DYqG/ZvFezDrJ8N5c7SW3yY32jyjw
         PQYspCZiSLC1E/3XYqMMRsSVUUfKaZDdaE0No=
MIME-Version: 1.0
From: Shahar Havivi <shaharh@gmail.com>
Date: Wed, 20 Jan 2010 13:59:08 +0200
Message-ID: <b0ae6fcc1001200359y8779182j76f92b50924b340b@mail.gmail.com>
Subject: [PATCH] Remove unused variables
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused fields in drivers/char/vt.c
variables orig_buf and orig_count are assigned but never used.

Shahar Havivi

---
 drivers/char/vt.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50faa1f..94f530a 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2119,8 +2119,6 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
    uint8_t inverse;
    uint8_t width;
    u16 himask, charmask;
-   const unsigned char *orig_buf = NULL;
-   int orig_count;

    if (in_interrupt())
        return count;
@@ -2142,8 +2140,6 @@ static int do_con_write(struct tty_struct *tty,
const unsigned char *buf, int co
        release_console_sem();
        return 0;
    }
-   orig_buf = buf;
-   orig_count = count;

    himask = vc->vc_hi_font_mask;
    charmask = himask ? 0x1ff : 0xff;
-- 
1.6.3.3
