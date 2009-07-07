Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZGGOgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZGGOgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZGGOfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:35:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005AbZGGOfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:35:12 -0400
Subject: [PATCH 12/22] trivial: fix typo "lock lock"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:48:18 +0530
Message-Id: <1246976298.3613.28.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "lock lock" with "lock"

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 fs/ufs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5faed79..a19c068 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -401,7 +401,7 @@ static int ufs_parse_options (char * options, unsigned * mount_options)
 			break;
 		case Opt_onerror_repair:
 			printk("UFS-fs: Unable to do repair on error, "
-				"will lock lock instead\n");
+				"will lock instead\n");
 			ufs_clear_opt (*mount_options, ONERROR);
 			ufs_set_opt (*mount_options, ONERROR_REPAIR);
 			break;
-- 
1.6.0.6



