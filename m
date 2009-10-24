Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZJXUBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZJXUBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 16:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZJXUBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 16:01:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56337 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZJXUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 16:01:08 -0400
Date: Sat, 24 Oct 2009 22:01:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, Greg KH <greg@kroah.com>
Subject: staging/dream: remove wakelock support from smd_rpcrouter.h
Message-ID: <20091024200108.GA23703@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wakelocks are power optimalization, not supported in mainline. Remove
them so that code compiles on mainline.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/drivers/staging/dream/smd/smd_rpcrouter.h
+++ b/drivers/staging/dream/smd/smd_rpcrouter.h
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/cdev.h>
 #include <linux/platform_device.h>
-#include <linux/wakelock.h>
 
 #include <mach/msm_smd.h>
 #include <mach/msm_rpcrouter.h>
@@ -144,7 +143,6 @@ struct msm_rpc_endpoint {
 	/* complete packets waiting to be read */
 	struct list_head read_q;
 	spinlock_t read_q_lock;
-	struct wake_lock read_q_wake_lock;
 	wait_queue_head_t wait_q;
 	unsigned flags;
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
