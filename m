Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbXDBLdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbXDBLdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbXDBLdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:33:54 -0400
Received: from ns.suse.de ([195.135.220.2]:50435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933960AbXDBLdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:33:53 -0400
From: Danny Kukawka <dkukawka@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add "optical" to sysfs "media" attribute
Date: Mon, 2 Apr 2007 13:32:47 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021332.48494.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <dkukawka@suse.de>
Subject: ide: add "optical" to sysfs "media" attribute

Add "optical" to sysfs "media" attribute as already in /proc

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--- linux-2.6.21-rc1/drivers/ide/ide.c	2007-03-21 14:07:18.000000000 +0100
+++ linux-2.6.21-rc1/drivers/ide/ide.c	2007-03-21 14:09:39.000000000 +0100
@@ -1952,6 +1952,8 @@
 		return "tape";
 	case ide_floppy:
 		return "floppy";
+	case ide_optical:
+		return "optical";
 	default:
 		return "UNKNOWN";
 	}
