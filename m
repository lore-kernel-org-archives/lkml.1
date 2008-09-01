Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYIAQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYIAQjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYIAQjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:39:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:45651 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYIAQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=COXa7JR+IMhw55/lj5+GLXfLYMbL7HCdhCH03i8lStFkhF8ubPuHX37zQ7QnQRl9iN
         b/ljAjDb9Z3zGW1yF4jI3ZsZOC/ThD5feJTgqLAQFWCKNt516JvunyhLa8RHO4ecG4/U
         O1iwBgLvH9vVpIwQErNQrhR9wlvdRW8nDv7uw=
Date: Mon, 1 Sep 2008 20:41:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: proc_sys_root tweak
Message-ID: <20080901164122.GA24546@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/proc_sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -395,10 +395,10 @@ static struct dentry_operations proc_sys_dentry_operations = {
 	.d_compare	= proc_sys_compare,
 };
 
-static struct proc_dir_entry *proc_sys_root;
-
 int proc_sys_init(void)
 {
+	struct proc_dir_entry *proc_sys_root;
+
 	proc_sys_root = proc_mkdir("sys", NULL);
 	proc_sys_root->proc_iops = &proc_sys_dir_operations;
 	proc_sys_root->proc_fops = &proc_sys_dir_file_operations;

