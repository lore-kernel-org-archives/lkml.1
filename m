Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZAERVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZAERVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZAERVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:21:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36617 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZAERVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:21:13 -0500
Date: Mon, 5 Jan 2009 17:21:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] missing include in cxgb3i
Message-ID: <20090105172111.GP28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it needs scatterlist.h - indirect chain of includes doesn't work on
a lot of targets.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 1a41f04..08f3a09 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/skbuff.h>
+#include <linux/scatterlist.h>
 
 /* from cxgb3 LLD */
 #include "common.h"
-- 
1.5.6.5


