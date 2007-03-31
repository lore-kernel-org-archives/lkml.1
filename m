Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXCaUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXCaUzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXCaUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:55:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39493 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608AbXCaUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:55:43 -0400
Date: Sat, 31 Mar 2007 22:55:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make struct proc_fdinfo_file_operations static
Message-ID: <20070331205543.GC14134@stusta.de>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070330010559.2a232d9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:05:59AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm2:
>...
> +add-file-position-info-to-proc.patch
> 
>  /proc feature work
>...


This patch makes the needlessly global
struct proc_fdinfo_file_operations static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.21-rc5-mm3/fs/proc/base.c.old	2007-03-31 22:07:21.000000000 +0200
+++ linux-2.6.21-rc5-mm3/fs/proc/base.c	2007-03-31 22:07:30.000000000 +0200
@@ -1515,7 +1515,7 @@
 	return err;
 }
 
-const struct file_operations proc_fdinfo_file_operations = {
+static const struct file_operations proc_fdinfo_file_operations = {
 	.open		= nonseekable_open,
 	.read		= proc_fdinfo_read,
 };

