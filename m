Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbZKEALM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbZKEALM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZKEALL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:11:11 -0500
Received: from xenotime.net ([72.52.64.118]:36149 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750890AbZKEALK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:11:10 -0500
Date: Wed, 04 Nov 2009 16:04:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/8] sound: use KERN_WARNING, not KERN_WARN
Message-ID: <1257379492822@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Use KERN_WARNING instead of KERN_WARN, which does not exist

Reported-by: Andrew Lyon <andrew.lyon@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jaroslav Kysela <perex@perex.cz>
Cc:	Takashi Iwai <tiwai@suse.de>
---
 sound/oss/sb_common.c |    4 ++--
 sound/oss/sb_ess.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- lnx-2632-rc6.orig/sound/oss/sb_common.c
+++ lnx-2632-rc6/sound/oss/sb_common.c
@@ -157,7 +157,7 @@ static void sb_intr (sb_devc *devc)
 				break;
 
 			default:
-				/* printk(KERN_WARN "Sound Blaster: Unexpected interrupt\n"); */
+				/* printk(KERN_WARNING "Sound Blaster: Unexpected interrupt\n"); */
 				;
 		}
 	}
@@ -177,7 +177,7 @@ static void sb_intr (sb_devc *devc)
 				break;
 
 			default:
-				/* printk(KERN_WARN "Sound Blaster: Unexpected interrupt\n"); */
+				/* printk(KERN_WARNING "Sound Blaster: Unexpected interrupt\n"); */
 				;
 		}
 	}
--- lnx-2632-rc6.orig/sound/oss/sb_ess.c
+++ lnx-2632-rc6/sound/oss/sb_ess.c
@@ -782,7 +782,7 @@ printk(KERN_INFO "FKS: ess_handle_channe
 			break;
 
 		default:;
-			/* printk(KERN_WARN "ESS: Unexpected interrupt\n"); */
+			/* printk(KERN_WARNING "ESS: Unexpected interrupt\n"); */
 	}
 }
 


-- 

