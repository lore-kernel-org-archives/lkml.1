Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXGQSeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXGQSeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXGQSeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:34:17 -0400
Received: from inti.inf.utfsm.cl ([200.1.21.155]:43636 "EHLO inti.inf.utfsm.cl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbXGQSeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:34:17 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 14:34:16 EDT
From: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: v9fs-developer@lists.sourceforge.net,
       "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Subject: [PATCH] fs/9p/v9fs.c: Delete unused p9_debug_level setting
Date: Tue, 17 Jul 2007 14:26:06 -0400
Message-Id: <11846967671229-git-send-email-vonbrand@inf.utfsm.cl>
X-Mailer: git-send-email 1.5.2.3
In-Reply-To: <11846967662438-git-send-email-vonbrand@inf.utfsm.cl>
References: <11846967662438-git-send-email-vonbrand@inf.utfsm.cl>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0rc6 (inti.inf.utfsm.cl [0.0.0.0]); Tue, 17 Jul 2007 14:25:52 -0400 (CLT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Horst H. von Brand <vonbrand@inf.utfsm.cl>

Signed-off-by: Horst H. von Brand <vonbrand@inf.utfsm.cl>
---
 fs/9p/v9fs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 45c3598..72ad365 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -131,7 +131,6 @@ static void v9fs_parse_options(char *options, struct v9fs_session_info *v9ses)
 		switch (token) {
 		case Opt_debug:
 			v9ses->debug = option;
-			p9_debug_level = option;
 			break;
 		case Opt_port:
 			v9ses->port = option;
-- 
1.5.2.3

