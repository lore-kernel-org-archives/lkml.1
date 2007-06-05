Return-Path: <linux-kernel-owner+w=401wt.eu-S932524AbXFEVvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbXFEVvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765487AbXFEVut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:50:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54671 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765558AbXFEVus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:50:48 -0400
Date: Tue, 5 Jun 2007 23:50:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [-mm patch] kernel/power/disk.c: make code static
Message-ID: <20070605215049.GI5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:58:23PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc2-mm1:
>...
> +swsusp-remove-code-duplication-between-diskc-and-userc.patch
>...
>  freezer/swsusp updates
>...

This patch makes needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/power/disk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc3-mm1/kernel/power/disk.c.old	2007-06-05 22:12:07.000000000 +0200
+++ linux-2.6.22-rc3-mm1/kernel/power/disk.c	2007-06-05 22:13:37.000000000 +0200
@@ -45,7 +45,7 @@
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-struct hibernation_ops *hibernation_ops;
+static struct hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
@@ -231,7 +231,7 @@
  *	to power off or reboot.
  */
 
-void power_down(void)
+static void power_down(void)
 {
 	switch (hibernation_mode) {
 	case HIBERNATION_TEST:

