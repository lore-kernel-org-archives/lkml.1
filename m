Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbXDJVIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbXDJVIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXDJVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:08:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47006 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753862AbXDJVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:08:19 -0400
Date: Tue, 10 Apr 2007 23:08:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make struct proc_kpagemap static
Message-ID: <20070410210826.GI28370@stusta.de>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm4:
>...
> +maps2-add-proc-kpagemap-interface.patch
> 
>  New interfaces for inspecting process memory status
>...


This patch makes the needlessly global truct proc_kpagemap static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc6-mm1/fs/proc/proc_misc.c.old	2007-04-10 00:52:35.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/proc/proc_misc.c	2007-04-10 00:52:49.000000000 +0200
@@ -732,7 +732,7 @@
 	return ret;
 }
 
-struct proc_dir_entry *proc_kpagemap;
+static struct proc_dir_entry *proc_kpagemap;
 static struct file_operations proc_kpagemap_operations = {
 	.llseek = mem_lseek,
 	.read = kpagemap_read,

