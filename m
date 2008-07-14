Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYGNWCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYGNWCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYGNWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:01:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842AbYGNWB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:01:56 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>
Subject: [PATCH 01/17] ocfs2: Add CONFIG_OCFS2_FS_STATS config option
Date: Mon, 14 Jul 2008 15:01:34 -0700
Message-Id: <1216072910-27226-2-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch adds config option CONFIG_OCFS2_FS_STATS to allow building
the fs with instrumentation enabled. An upcoming patch will provide
support to instrument cluster locking, which is a crucial overhead in
a cluster file system. This config option allows users to avoid the cpu
and memory overhead that is involved in gathering such statistics.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 2694648..9c07a4f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -470,6 +470,14 @@ config OCFS2_FS_USERSPACE_CLUSTER
 	  It is safe to say Y, as the clustering method is run-time
 	  selectable.
 
+config OCFS2_FS_STATS
+	bool "OCFS2 statistics"
+	depends on OCFS2_FS
+	default y
+	help
+	  This option allows some fs statistics to be captured. Enabling
+	  this option may increase the memory consumption.
+
 config OCFS2_DEBUG_MASKLOG
 	bool "OCFS2 logging support"
 	depends on OCFS2_FS
-- 
1.5.4.1

