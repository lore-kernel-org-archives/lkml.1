Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0CBVNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:13:30 -0500
Received: from [206.15.93.42] ([206.15.93.42]:10397 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751588Ab0CBVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:13:29 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: use C99 syntax for struct initializer
Date: Tue, 2 Mar 2010 14:13:22 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003021413.23114.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use C99 syntax for the struct file_operations initialization.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..0183005 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -850,12 +850,12 @@ static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
  *  register_chrdev
  *****************************************************/
 static struct file_operations dt3155_fops = {
-  read:		dt3155_read,
-  ioctl:		dt3155_ioctl,
-  mmap:		dt3155_mmap,
-  poll:           dt3155_poll,
-  open:		dt3155_open,
-  release:	dt3155_close
+	.read		= dt3155_read,
+	.ioctl		= dt3155_ioctl,
+	.mmap		= dt3155_mmap,
+	.poll		= dt3155_poll,
+	.open		= dt3155_open,
+	.release	= dt3155_close,
 };
 
 
