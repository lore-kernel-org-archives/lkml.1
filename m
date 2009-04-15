Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZDORYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZDORYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZDORYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:24:00 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:42930 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZDORX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:23:59 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/3] Export filemap_write_and_wait_range
Date: Wed, 15 Apr 2009 13:22:37 -0400
Message-Id: <abbad87ab84075cbac38f4cd99507a4c605fd731.1239815649.git.chris.mason@oracle.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49E617EB.0104:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wasn't exported before and is used by the ext3 data=guarded code

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 mm/filemap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2e2d38e..04e2160 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -441,6 +441,7 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 	}
 	return err;
 }
+EXPORT_SYMBOL(filemap_write_and_wait_range);
 
 /**
  * add_to_page_cache_locked - add a locked page to the pagecache
-- 
1.6.0.2

