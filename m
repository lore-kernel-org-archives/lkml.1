Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbYESBOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbYESBOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbYESBLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:04 -0400
Received: from ns.suse.de ([195.135.220.2]:35878 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbYESBKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:10:24 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:17 +1000
Message-Id: <1080519011017.7639@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 002 of 10] md: proper extern for mdp_major
References: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper extern for mdp_major in include/linux/raid/md.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/raid/md.h |    2 ++
 ./init/do_mounts_md.c     |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff .prev/include/linux/raid/md.h ./include/linux/raid/md.h
--- .prev/include/linux/raid/md.h	2008-05-19 11:02:06.000000000 +1000
+++ ./include/linux/raid/md.h	2008-05-19 11:02:24.000000000 +1000
@@ -72,6 +72,8 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+extern int mdp_major;
+
 extern int register_md_personality (struct mdk_personality *p);
 extern int unregister_md_personality (struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),

diff .prev/init/do_mounts_md.c ./init/do_mounts_md.c
--- .prev/init/do_mounts_md.c	2008-05-19 11:02:06.000000000 +1000
+++ ./init/do_mounts_md.c	2008-05-19 11:02:24.000000000 +1000
@@ -24,7 +24,6 @@ static struct {
 
 static int md_setup_ents __initdata;
 
-extern int mdp_major;
 /*
  * Parse the command-line parameters given our kernel, but do not
  * actually try to invoke the MD device now; that is handled by
