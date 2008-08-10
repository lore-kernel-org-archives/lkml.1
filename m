Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYHJNP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYHJNP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 09:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYHJNPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 09:15:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:32649 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbYHJNPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 09:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=e/DcoxS+qK5jYVf6zYHwC6G85uqJxxTEU6y9ItR5RVyz7StOqG2LUDfOkfJknOWJic
         rNUV3gFFVuJqhCv3O7IUVXc312Qpalv66K0ulxqVYCJrDpvYY5UwefnmtSyAtc8c2Lum
         7st3GGcx5ZayA2esWUcVuf8DQX5Fswww42x1g=
Date: Sun, 10 Aug 2008 21:15:45 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: jack@suse.cz
Subject: fs/reiserfs/super.c: removed duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080810211208.A47C.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include <linux/quotaops.h> in 
fs/reiserfs/super.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 282a135..d318c7e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -27,7 +27,6 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
-#include <linux/quotaops.h>

 struct file_system_type reiserfs_fs_type;


