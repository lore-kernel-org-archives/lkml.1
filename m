Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZGXWaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZGXWaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZGXWaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:30:08 -0400
Received: from kroah.org ([198.145.64.141]:46280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZGXWaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:30:05 -0400
Date: Fri, 24 Jul 2009 15:29:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.30.3
Message-ID: <20090724222917.GD30562@kroah.com>
References: <20090724222900.GC30562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724222900.GC30562@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ab8cda6..5c9795d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 30
-EXTRAVERSION = .2
+EXTRAVERSION = .3
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 5c1a2c0..9ae9cd3 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
 
 static int edid_checksum(unsigned char *edid)
 {
-	unsigned char i, csum = 0, all_null = 0;
-	int err = 0, fix = check_edid(edid);
+	unsigned char csum = 0, all_null = 0;
+	int i, err = 0, fix = check_edid(edid);
 
 	if (fix)
 		fix_edid(edid, fix);
