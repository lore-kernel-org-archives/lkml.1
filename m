Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXLIVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXLIVby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLIVbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:31:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:49900 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXLIVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=sws6VyyxXvmWWqCCFhVTIxwVR9ULHkAc0R7iQqyb8J5WWpy271ln3a8e3q8cNJhz1xLOCW/b+wurKu5Usq22ynA/ZYLuhlh20/Tgh2J0CoBzrHSlWzJyG/xTVQSdGj1xVpn1u9Ge7C6t686/C3CZNwxTZSt39j36sJ7LOb6yCI0=
Date: Sun, 9 Dec 2007 22:32:52 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vgacon: fix sparse warning about shadowing 'i' symbol
Message-ID: <20071209213247.GD9440@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vgacon: fix sparse warning about shadowing 'i' symbol

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 drivers/video/console/vgacon.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index f65bcd3..6df29a6 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1153,8 +1153,6 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)

 	/* if 512 char mode is already enabled don't re-enable it. */
 	if ((set) && (ch512 != vga_512_chars)) {
-		int i;
-
 		/* attribute controller */
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			struct vc_data *c = vc_cons[i].d;
