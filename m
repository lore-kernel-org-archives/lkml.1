Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbXKOQMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbXKOQMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758269AbXKOQMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:12:06 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:26315 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246AbXKOQMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:12:05 -0500
Date: Thu, 15 Nov 2007 19:11:14 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: remove MODULE_LICENSE
Message-ID: <20071115161114.GD6216@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

proc is not modular, so MODULE_LICENSE just expands to empty space. proc
without doubts remains GPLed.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -476,4 +476,3 @@ out_no_root:
 	de_put(&proc_root);
 	return -ENOMEM;
 }
-MODULE_LICENSE("GPL");

