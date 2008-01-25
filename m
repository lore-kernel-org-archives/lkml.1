Return-Path: <linux-kernel-owner+w=401wt.eu-S932867AbYAYIgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbYAYIgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764039AbYAYIBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763704AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 185/196] UIO: constify function pointer tables
Date: Thu, 24 Jan 2008 23:33:34 -0800
Message-Id: <1201246425-5058-106-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 03b66fb..cc246fa 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -39,7 +39,7 @@ struct uio_device {
 
 static int uio_major;
 static DEFINE_IDR(uio_idr);
-static struct file_operations uio_fops;
+static const struct file_operations uio_fops;
 
 /* UIO class infrastructure */
 static struct uio_class {
@@ -508,7 +508,7 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	}
 }
 
-static struct file_operations uio_fops = {
+static const struct file_operations uio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uio_open,
 	.release	= uio_release,
-- 
1.5.3.8

