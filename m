Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbXDJLeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbXDJLeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDJLeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:34:08 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58909 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbXDJLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:34:07 -0400
X-Originating-Ip: 74.109.98.130
Date: Tue, 10 Apr 2007 07:32:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] VIDEO: Add spaces on either side of the case "..." operator.
Message-ID: <Pine.LNX.4.64.0704100729130.13834@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Following the programming advice laid down in the gcc manual, make
sure the case "..." operator has spaces on either side.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

These are the only other examples of this in the entire kernel source
tree, so no need to worry about an impending deluge of related
patches.


 drivers/video/modedb.c |    4 ++--
 drivers/video/pxafb.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 3e51794..3741ad7 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -395,7 +395,7 @@ static int my_atoi(const char *name)

     for (;; name++) {
 	switch (*name) {
-	    case '0'...'9':
+	    case '0' ... '9':
 		val = 10*val+(*name-'0');
 		break;
 	    default:
@@ -548,7 +548,7 @@ int fb_find_mode(struct fb_var_screeninfo *var,
 		    } else
 			goto done;
 		    break;
-		case '0'...'9':
+		case '0' ... '9':
 		    break;
 		case 'M':
 		    if (!yres_specified)
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index b4947c8..4a6cacc 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1203,7 +1203,7 @@ static int __init pxafb_parse_options(struct device *dev, char *options)
 					} else
 						goto done;
 					break;
-				case '0'...'9':
+				case '0' ... '9':
 					break;
 				default:
 					goto done;
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
