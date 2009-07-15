Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZGOLvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZGOLvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZGOLvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:51:31 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:56454 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZGOLva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=L6MvbWUKUu1dxDfexAgYJ6sfhL4plCA9vLOKK8RztjNdz9ycuqMvFEmgO/GBNsTLtV
         6Lnrm5S+HFb86V5xUsZcIQhdFPZkoeZCq4wAoUBmLJjffZxX91QsaAD6IKCiLWklyRj8
         5jwZ3X6yDiLapfSOg1FRnOTvOm+jOmRI5izDk=
Date: Wed, 15 Jul 2009 13:52:50 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PATCH - Fix backlight compilation error on jornada700
Message-Id: <20090715135250.5f1de20a.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__15_Jul_2009_13_52_50_+0200_YvNjTo/Bj7+_0T58"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__15_Jul_2009_13_52_50_+0200_YvNjTo/Bj7+_0T58
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

This fixes compilation error on jornada700_bl.c. 

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index c3ebb6b..7aed256 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -72,7 +72,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
 			printk(KERN_INFO "bl : failed to set brightness\n");
 			ret = -ETIMEDOUT;
-			goto out
+			goto out;
 		}
 
 		/* at this point we expect that the mcu has accepted


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Multipart=_Wed__15_Jul_2009_13_52_50_+0200_YvNjTo/Bj7+_0T58
Content-Type: application/octet-stream;
 name="jornada_backlight.patch"
Content-Disposition: attachment;
 filename="jornada_backlight.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmwuYyBiL2Ry
aXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmwuYwppbmRleCBjM2ViYjZiLi43YWVk
MjU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3ZpZGVvL2JhY2tsaWdodC9qb3JuYWRhNzIwX2JsLmMK
KysrIGIvZHJpdmVycy92aWRlby9iYWNrbGlnaHQvam9ybmFkYTcyMF9ibC5jCkBAIC03Miw3ICs3
Miw3IEBAIHN0YXRpYyBpbnQgam9ybmFkYV9ibF91cGRhdGVfc3RhdHVzKHN0cnVjdCBiYWNrbGln
aHRfZGV2aWNlICpiZCkKIAkJaWYgKGpvcm5hZGFfc3NwX2J5dGUoU0VUQlJJR0hUTkVTUykgIT0g
VFhEVU1NWSkgewogCQkJcHJpbnRrKEtFUk5fSU5GTyAiYmwgOiBmYWlsZWQgdG8gc2V0IGJyaWdo
dG5lc3NcbiIpOwogCQkJcmV0ID0gLUVUSU1FRE9VVDsKLQkJCWdvdG8gb3V0CisJCQlnb3RvIG91
dDsKIAkJfQogCiAJCS8qIGF0IHRoaXMgcG9pbnQgd2UgZXhwZWN0IHRoYXQgdGhlIG1jdSBoYXMg
YWNjZXB0ZWQK

--Multipart=_Wed__15_Jul_2009_13_52_50_+0200_YvNjTo/Bj7+_0T58--
