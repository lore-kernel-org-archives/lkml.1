Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbYBQITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbYBQITS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbYBQIRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:17:39 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36821 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbYBQIRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:17:38 -0500
Date: Sun, 17 Feb 2008 10:17:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] gfs2/ops_file.c should #include "ops_inode.h"
Message-ID: <20080217081712.GF3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case for gfs2_set_inode_flags()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
34f925ebad8d18c4061536e275e33e888f827fd6 diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index f4842f2..64fd81c 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -39,6 +39,7 @@
 #include "util.h"
 #include "eaops.h"
 #include "ops_address.h"
+#include "ops_inode.h"
 
 /**
  * gfs2_llseek - seek to a location in a file

