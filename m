Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYDUIuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYDUIuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYDUItz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:49:55 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41074 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbYDUIty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:49:54 -0400
Date: Mon, 21 Apr 2008 11:49:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct ocfs2_control_device static
Message-ID: <20080421084926.GS26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct ocfs2_control_device 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d8837f8ed79bc615105e5ca2724c3d22c9f26089 diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 7428663..b503772 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -635,7 +635,7 @@ static const struct file_operations ocfs2_control_fops = {
 	.owner   = THIS_MODULE,
 };
 
-struct miscdevice ocfs2_control_device = {
+static struct miscdevice ocfs2_control_device = {
 	.minor		= MISC_DYNAMIC_MINOR,
 	.name		= "ocfs2_control",
 	.fops		= &ocfs2_control_fops,

