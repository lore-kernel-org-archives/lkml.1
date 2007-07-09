Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbXGIQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbXGIQld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbXGIQYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264AbXGIQYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:49 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] git-gfs2-nmw-build-fix
Date: Mon,  9 Jul 2007 17:02:58 +0100
Message-Id: <11839970921764-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970914023-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
 <11839970852076-git-send-email-swhiteho@redhat.com>
 <11839970871671-git-send-email-swhiteho@redhat.com>
 <1183997089710-git-send-email-swhiteho@redhat.com>
 <11839970914023-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org <akpm@linux-foundation.org>

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 73d44f5..0553a61 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -728,7 +728,7 @@ static int tcp_accept_from_sock(struct connection *con)
 		else {
 			printk("Extra connection from node %d attempted\n", nodeid);
 			result = -EAGAIN;
-			up_write(&newcon->sock_sem);
+			mutex_unlock(&newcon->sock_mutex);
 			goto accept_err;
 		}
 	}
-- 
1.5.1.2

