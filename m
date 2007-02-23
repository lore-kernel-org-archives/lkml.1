Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXBWXRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXBWXRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933271AbXBWXRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:35271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933276AbXBWXRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/9] make kernel/kmod.c:kmod_mk static
Date: Fri, 23 Feb 2007 15:15:54 -0800
Message-Id: <11722725761560-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <11722725722238-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de> <11722725623183-git-send-email-gregkh@suse.de> <1172272565581-git-send-email-gregkh@suse.de> <1172272569255-git-send-email-gregkh@suse.de> <11722725722238-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global struct kmod_mk static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/kmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9f923f8..f936108 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -48,7 +48,7 @@ static struct workqueue_struct *khelper_wq;
 	modprobe_path is set via /proc/sys.
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
-struct module_kobject kmod_mk;
+static struct module_kobject kmod_mk;
 
 /**
  * request_module - try to load a kernel module
-- 
1.5.0.1

