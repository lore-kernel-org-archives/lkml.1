Return-Path: <linux-kernel-owner+w=401wt.eu-S1751359AbZIVSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbZIVSlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZIVSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:41:43 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50668 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZIVSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VjufGCj4KNlbgBnM2WDDuwx8pw4teBJqyroJy15fGNMtQ6vNS72hUR1P4SRe5KeQxv
         2KIMy8cnN7dLa5dhEnOxVo5qm3JRCOju0TKyOiRQkIcbxnWjFzMpU6XVZEeqGCbmPTCn
         aVm3uE//cHHglajAw/rcWYkzfR3Pnt55OShQ4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2009 20:43:29 +0200
Message-Id: <20090922184329.7695.35349.sendpatchset@localhost.localdomain>
In-Reply-To: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
References: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/8] Staging: rt3090: disable HAS_ATE option
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3090: disable HAS_ATE option

Disable ATE debugging functionality.

This makes rt3090 match other Ralink drivers and V2.2.0.0 vendor version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt3090/config.mk |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/staging/rt3090/config.mk
===================================================================
--- a/drivers/staging/rt3090/config.mk
+++ b/drivers/staging/rt3090/config.mk
@@ -1,5 +1,5 @@
 # Support ATE function
-HAS_ATE=y
+HAS_ATE=n
 
 # Support 28xx QA ATE function
 HAS_28xx_QA=n
