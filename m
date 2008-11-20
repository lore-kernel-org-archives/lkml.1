Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYKTRCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYKTRCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYKTRBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:01:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:6218 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbYKTRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EQMkh/w1lr08O8HowGC9CLAiyo+HU0DN7DT6pttAR7gz6WHTxt00x6SWM9LExQX98t
         F08Fn49bFPW/Mk0Ap9q6YiKlfBMnZSidUJHw+bX5eNC2GzAcWTlQHTc+ap1hRg6y/+p0
         dySaqO+5tyZR8KE5YJQUVI9XxXFJGnRhgFqRE=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused variables from the cirrusfb driver
Date: Thu, 20 Nov 2008 11:03:22 -0700
Message-Id: <1227204203-32112-2-git-send-email-aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227204203-32112-1-git-send-email-aciddeath@gmail.com>
References: <1227204203-32112-1-git-send-email-aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove i and s vars from cirrusfb_setup as they are not used
anywhere in that function. This fixes 2 unused vars build warnings.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/video/cirrusfb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 8a87602..a2aa6dd 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
 
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options) {
-	char *this_opt, s[32];
-	int i;
+	char *this_opt;
 
 	DPRINTK("ENTER\n");
 
-- 
1.5.6.4

