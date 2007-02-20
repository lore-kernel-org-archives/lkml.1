Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbXBTAIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbXBTAIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXBTAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:21 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36125 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965554AbXBTAHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:50 -0500
Date: Tue, 20 Feb 2007 01:07:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [-mm patch] make kernel/kmod.c:kmod_mk static
Message-ID: <20070220000749.GD13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +gregkh-driver-driver-core-let-request_module-send-a-sys-modules-kmod-uevent.patch
>...
>  driver tree updates
>...


This patch makes the needlessly global struct kmod_mk static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/kernel/kmod.c.old	2007-02-18 23:06:28.000000000 +0100
+++ linux-2.6.20-mm2/kernel/kmod.c	2007-02-18 23:06:35.000000000 +0100
@@ -48,7 +48,7 @@
 	modprobe_path is set via /proc/sys.
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
-struct module_kobject kmod_mk;
+static struct module_kobject kmod_mk;
 
 /**
  * request_module - try to load a kernel module

