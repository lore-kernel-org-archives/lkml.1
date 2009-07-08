Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbZGHQHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbZGHQHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbZGHQFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:05:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:53234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbZGHQFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:05:15 -0400
Subject: [PATCH 34/44] includecheck fix: fs/xfs, xfs_iops.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:16:11 +0530
Message-Id: <1247067971.4382.94.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  fs/xfs/linux-2.6/xfs_iops.c: xfs_acl.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 58973bb..793a146 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -43,7 +43,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
-- 
1.6.0.6



