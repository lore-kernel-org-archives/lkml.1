Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYJUVYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYJUVYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYJUVYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:24:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52995 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751907AbYJUVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:24:41 -0400
Date: Tue, 21 Oct 2008 16:24:40 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] sgi-xp: define xp_partition_id and xp_region_size
Message-ID: <20081021212440.GE14386@sgi.com>
References: <20081021212054.GB14386@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021212054.GB14386@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define xp_partition_id and xp_region_size to their correct values.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xp_uv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-xp/xp_uv.c
===================================================================
--- linux.orig/drivers/misc/sgi-xp/xp_uv.c	2008-10-20 14:21:31.000000000 -0500
+++ linux/drivers/misc/sgi-xp/xp_uv.c	2008-10-20 14:29:31.000000000 -0500
@@ -119,8 +119,8 @@ xp_init_uv(void)
 	BUG_ON(!is_uv());
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_UV;
-	xp_partition_id = 0;	/* !!! not correct value */
-	xp_region_size = 0;	/* !!! not correct value */
+	xp_partition_id = sn_partition_id;
+	xp_region_size = sn_region_size;
 
 	xp_pa = xp_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
