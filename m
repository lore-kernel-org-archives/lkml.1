Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYDZBkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYDZBkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 21:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYDZBkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 21:40:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:53612 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYDZBj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 21:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pj3/KrirqONB640G9Udl0aT+20j0wSrhIOFf+sHK5FpWckvz2RUc4slyvX2o6B9/ywe8zCxtfklbvVuw0S66mpdG4FOeuJ9+65ROCNwyQBJZDo3JzOxIfF4aik7+eq88vgiTpm3s/El+FNWwFLSd82lEPHci2G3X9WLCWYLbf10=
Subject: [BUILDFIX PATCH] mac-hid: fix build after lockdep annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 18:40:01 -0700
Message-Id: <1209174001.14173.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/macintosh/mac_hid.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index f972ff3..cc9f275 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -114,8 +114,8 @@ static int emumousebtn_input_register(void)
 	if (!emumousebtn)
 		return -ENOMEM;
 
-	lockdep_set_class(emumousebtn->event_lock, &emumousebtn_event_class);
-	lockdep_set_class(emumousebtn->mutex, &emumousebtn_mutex_class);
+	lockdep_set_class(&emumousebtn->event_lock, &emumousebtn_event_class);
+	lockdep_set_class(&emumousebtn->mutex, &emumousebtn_mutex_class);
 
 	emumousebtn->name = "Macintosh mouse button emulation";
 	emumousebtn->id.bustype = BUS_ADB;
-- 
1.5.5.1.270.g89765



