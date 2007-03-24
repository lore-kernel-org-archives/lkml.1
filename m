Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbXCXNIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbXCXNIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXCXNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:07:21 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33371 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752144AbXCXNHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:07:14 -0400
Date: Sat, 24 Mar 2007 14:07:17 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport bio_{,un}map_user
Message-ID: <20070324130717.GL752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc3-mm1:
>...
>  git-scsi-misc.patch
>...
>  git trees
>...


bio_{,un}map_user do no longer have any modular users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/fs/bio.c.old	2007-03-24 11:42:28.000000000 +0100
+++ linux-2.6.21-rc4-mm1/fs/bio.c	2007-03-24 11:42:39.000000000 +0100
@@ -1253,8 +1253,6 @@
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
-EXPORT_SYMBOL(bio_map_user);
-EXPORT_SYMBOL(bio_unmap_user);
 EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);

