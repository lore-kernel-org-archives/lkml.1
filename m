Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0BWEwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 23:52:25 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30724 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0BWEwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 23:52:23 -0500
Date: Mon, 22 Feb 2010 21:52:21 -0700
From: dann frazier <dannf@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] cciss: export linux/cciss_defs.h header
Message-ID: <20100223045221.GG3923@ldl.fc.hp.com>
References: <20100223132619.e6f5ff0e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223132619.e6f5ff0e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make headers_check' began to fail after cciss_defs.h was introduced in:
   429c42c9d246f5bda868495c09974312a0177328

usr/include/linux/cciss_ioctl.h:6: included file 'linux/cciss_defs.h' is not exported

Fix this by exporting cciss_defs.h

Signed-off-by: dann frazier <dannf@hp.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 756f831..91be0d8 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -43,6 +43,7 @@ header-y += blkpg.h
 header-y += bpqether.h
 header-y += bsg.h
 header-y += can.h
+header-y += cciss_defs.h
 header-y += cdk.h
 header-y += chio.h
 header-y += coda_psdev.h
-- 
1.5.6.5

