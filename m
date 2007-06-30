Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXF3QcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXF3QcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXF3QcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 12:32:04 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:41190 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbXF3QcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 12:32:03 -0400
Date: Sat, 30 Jun 2007 18:32:00 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH v2 1/5] uvesafb: export fb_destroy_modelist
Message-ID: <20070630163200.GB3838@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make fb_destroy_modelist an exported symbol for use in the uvesafb driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
 drivers/video/modedb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 3741ad7..d351eed 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -938,6 +938,7 @@ void fb_destroy_modelist(struct list_head *head)
 		kfree(pos);
 	}
 }
+EXPORT_SYMBOL_GPL(fb_destroy_modelist);
 
 /**
  * fb_videomode_to_modelist: convert mode array to mode list

