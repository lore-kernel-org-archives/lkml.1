Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab0BXW3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:29:51 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59754 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449Ab0BXW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:29:49 -0500
Date: Wed, 24 Feb 2010 14:29:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>
Subject: [PATCH] drm/ttm: fix function prototype to match implementation
Message-Id: <20100224142914.b0954c41.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B85A84B.002E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function prototype to match its actual usage and implementation.

drivers/gpu/drm/ttm/ttm_bo_util.c:341:10: error: symbol 'ttm_io_prot' redeclared with different type (originally declared at include/drm/ttm/ttm_bo_driver.h:911) - incompatible argument 1 (different signedness)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	David Airlie <airlied@linux.ie>
---
 include/drm/ttm/ttm_bo_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.33-rc8-git8.orig/include/drm/ttm/ttm_bo_driver.h
+++ linux-2.6.33-rc8-git8/include/drm/ttm/ttm_bo_driver.h
@@ -908,7 +908,7 @@ extern int ttm_bo_move_accel_cleanup(str
  * Utility function that returns the pgprot_t that should be used for
  * setting up a PTE with the caching model indicated by @c_state.
  */
-extern pgprot_t ttm_io_prot(enum ttm_caching_state c_state, pgprot_t tmp);
+extern pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp);
 
 #if (defined(CONFIG_AGP) || (defined(CONFIG_AGP_MODULE) && defined(MODULE)))
 #define TTM_HAS_AGP
