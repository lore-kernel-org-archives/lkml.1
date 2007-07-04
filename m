Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbXGDLHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbXGDLHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbXGDLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:07:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:2658 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068AbXGDLHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:07:32 -0400
Date: Wed, 4 Jul 2007 15:07:19 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] .gitignore update
Message-ID: <20070704110719.GA11069@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

headers_install by default puts headers into usr/include/ .
They're auto-generated, so should be ignored.

Same for *.orig, *.rej .

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 .gitignore     |    3 +++
 usr/.gitignore |    1 +
 2 files changed, 4 insertions(+)

--- a/.gitignore
+++ b/.gitignore
@@ -45,3 +45,6 @@ series
 
 # cscope files
 cscope.*
+
+*.orig
+*.rej
--- a/usr/.gitignore
+++ b/usr/.gitignore
@@ -5,3 +5,4 @@ gen_init_cpio
 initramfs_data.cpio
 initramfs_data.cpio.gz
 initramfs_list
+include

