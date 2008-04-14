Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbYDNO1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbYDNO1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761402AbYDNOWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:22:04 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41425 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761849AbYDNOWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:22:02 -0400
Date: Mon, 14 Apr 2008 17:20:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] parport/share.c: proper externs
Message-ID: <20080414142057.GY6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper externs for parport_default_timeslice and 
parport_default_spintime in include/linux/parport.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/parport/procfs.c |    3 ---
 include/linux/parport.h  |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

4b9040d06db3fe544aa9971ba18184e2fb9b52ce diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index d950fc3..554e11f 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -429,9 +429,6 @@ struct parport_default_sysctl_table
 	ctl_table dev_dir[2];
 };
 
-extern unsigned long parport_default_timeslice;
-extern int parport_default_spintime;
-
 static struct parport_default_sysctl_table
 parport_default_sysctl_table = {
 	.sysctl_header	= NULL,
diff --git a/include/linux/parport.h b/include/linux/parport.h
index d1ad546..2794fcc 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -560,5 +560,8 @@ extern int parport_device_proc_unregister(struct pardevice *device);
 
 #endif /*  !CONFIG_PARPORT_NOT_PC  */
 
+extern unsigned long parport_default_timeslice;
+extern int parport_default_spintime;
+
 #endif /* __KERNEL__ */
 #endif /* _PARPORT_H_ */

