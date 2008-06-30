Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbYF3Szz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbYF3Szz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbYF3Szp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:55:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:4214 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYF3Szn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=bl1W/1Oa1aS2FBORFB+ZhF5scgbsMCzMY0MrGPz/7pba/p67ai4JHEEdYSlFYYqy65
         xcqkxSmFes6ZIj88vNIQdRBesxOkTQtlMgC0MxBRoOuQQZnEkg8pWeDECTcoU4SjcWIS
         Duf6gc7COH0w83h/0FHtg1e1OuHVQWBQDDaMQ=
Message-ID: <ea11fea30806301155u3daccf0eo2daf690396b5616f@mail.gmail.com>
Date: Tue, 1 Jul 2008 00:25:37 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] ext4 : Remove unused variable journal from ext4_show_options
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=======================================================================

Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

---
 fs/ext4/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb96f12..d9d12c1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -671,7 +671,6 @@ static int ext4_show_options(struct seq_file *seq,
struct vfsmount *vfs)
        unsigned long def_mount_opts;
        struct super_block *sb = vfs->mnt_sb;
        struct ext4_sb_info *sbi = EXT4_SB(sb);
-       journal_t *journal = sbi->s_journal;
        struct ext4_super_block *es = sbi->s_es;

        def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
-- 
1.5.4.3

========================================================================

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
