Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYLVWJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYLVWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYLVVua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:50:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:38732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231AbYLVVu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:50:28 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 56/56] ocfs2/quota: Add QUOTA in mlog_attribute.
Date: Mon, 22 Dec 2008 13:48:37 -0800
Message-Id: <1229982517-3455-57-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

A new mlog mask has to be added into mlog_attribute before it can
be really used in mlog. ML_QUOTA is only added in masklog.h, so
add it to the array to enable it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/cluster/masklog.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index d8a0cb9..96df541 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -110,6 +110,7 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(QUORUM),
 	define_mask(EXPORT),
 	define_mask(XATTR),
+	define_mask(QUOTA),
 	define_mask(ERROR),
 	define_mask(NOTICE),
 	define_mask(KTHREAD),
-- 
1.5.6

