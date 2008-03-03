Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYCCTby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYCCTby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYCCTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:31:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:49874 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYCCTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L3NOPrgTOH9w79X97v1JLjhgTdUQpAltPBjWrIBTNYsPGR63Zu7sjtfDg6Hz67bUcjc6pZcQGXyzogglmpQlaKT9aU4DYpW718+JD5P3M6hB8ijue9UNLgVgPwDOnPD7/uDBtgtHgnzmwd1ViK+vdxej1PPL5c7nQp1fLkkcIuw=
Subject: [PATCH] uml: replace remaining __FUNCTION__ occurance
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:31:42 -0800
Message-Id: <1204572702.3266.48.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/um/drivers/line.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 2c898c4..10b86e1 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -304,7 +304,7 @@ int line_ioctl(struct tty_struct *tty, struct file * file,
 				break;
 		if (i == ARRAY_SIZE(tty_ioctls)) {
 			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
-			       __FUNCTION__, tty->name, cmd);
+			       __func__, tty->name, cmd);
 		}
 		ret = -ENOIOCTLCMD;
 		break;
-- 
1.5.4.3.500.g83a2c



