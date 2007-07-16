Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXGPSwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXGPSwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbXGPSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:51:15 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:35826 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbXGPSvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:51:13 -0400
Message-ID: <469BBE14.3030006@namesys.com>
Date: Mon, 16 Jul 2007 22:51:00 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>
CC: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [patch 2/3] reiser4: fix read_tail
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------030807070801090609000905"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030807070801090609000905
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit




--------------030807070801090609000905
Content-Type: text/x-patch;
 name="reiser4-fix-read_tail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-fix-read_tail.patch"

Update hint when reading tails

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.22-rc6-mm1/fs/reiser4/plugin/item/tail.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc6-mm1/fs/reiser4/plugin/item/tail.c.orig
+++ linux-2.6.22-rc6-mm1/fs/reiser4/plugin/item/tail.c
@@ -758,7 +758,7 @@
 		coord->unit_pos--;
 		coord->between = AFTER_UNIT;
 	}
-
+	reiser4_set_hint(hint, &f->key, ZNODE_READ_LOCK);
 	return 0;
 }
 


--------------030807070801090609000905--
