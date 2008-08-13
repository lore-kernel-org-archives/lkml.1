Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbYHMIql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbYHMIql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYHMIjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37210 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYHMIjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:44 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: support splice_write
Date: Wed, 13 Aug 2008 13:17:51 +0300
Message-Id: <1218622675-28853-23-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:04.0284 (UTC) FILETIME=[0AD919C0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Sogor <weth@inf.u-szeged.hu>

Signed-off-by: Zoltan Sogor <weth@inf.u-szeged.hu>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 9fecab2..4071d1c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1271,6 +1271,7 @@ struct file_operations ubifs_file_operations = {
 	.fsync          = ubifs_fsync,
 	.unlocked_ioctl = ubifs_ioctl,
 	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ubifs_compat_ioctl,
 #endif
-- 
1.5.4.1

