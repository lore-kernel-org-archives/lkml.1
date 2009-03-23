Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZCWW6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZCWW6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZCWW6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:58:39 -0400
Received: from mail.open.by ([193.232.92.17]:53936 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZCWW6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:58:38 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 18:58:38 EDT
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 7829 [Mar 23 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {UDS BL}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0278], KAS30/Release
Message-ID: <49C806A6.2000007@mail.by>
Date: Tue, 24 Mar 2009 00:01:10 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.29-rc8] fb: nvidiafb recognizes geforcego 7300 chip as
 mobile
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

nvidiafb recognizes geforcego 7300 chip as mobile

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
---
diff --git a/drivers/video/nvidia/nv_setup.c b/drivers/video/nvidia/nv_setup.c
index d9627b5..135ae18 100644
--- a/drivers/video/nvidia/nv_setup.c
+++ b/drivers/video/nvidia/nv_setup.c
@@ -362,6 +362,7 @@ int NVCommonSetup(struct fb_info *info)
 	case 0x0186:
 	case 0x0187:
 	case 0x018D:
+	case 0x01D7:
 	case 0x0228:
 	case 0x0286:
 	case 0x028C:

