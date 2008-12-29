Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYL2W5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYL2W5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYL2W4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:56:54 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:43873 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYL2W4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:56:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Hnogck5IEa/ZAOM9HaToCupeTipVnhFjJFEoDtNeMz611qDa9b8HOJ42e/QfHRyMpe
         Rc+nrddBSDmXUrpO+zicHMeXrYSXLr/gG0dJ2jQt/1CIUVqhW1M1rh60CZSH52+UEhI9
         qPBTiNuOBgatSlZpGWl3R+uKI/SXNPwbrEWQQ=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, corbet@lwn.net,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix small typo in bio.h's documentation
Date: Mon, 29 Dec 2008 20:56:16 -0200
Message-Id: <1230591376-9001-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.302.gccd4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 include/linux/bio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6a64209..b29e2b3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -135,7 +135,7 @@ struct bio {
  * bit 1 -- rw-ahead when set
  * bit 2 -- barrier
  *	Insert a serialization point in the IO queue, forcing previously
- *	submitted IO to be completed before this oen is issued.
+ *	submitted IO to be completed before this one is issued.
  * bit 3 -- synchronous I/O hint: the block layer will unplug immediately
  *	Note that this does NOT indicate that the IO itself is sync, just
  *	that the block layer will not postpone issue of this IO by plugging.
-- 
1.6.1.302.gccd4d

