Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0BCDrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:47:16 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45784 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab0BCDpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:49 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 05/11] tree-wide: Fix spelling of 'argument'
Date: Wed,  3 Feb 2010 00:48:21 +0800
Message-Id: <1265129307-18201-5-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-4-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 Documentation/s390/kvm.txt      |    2 +-
 drivers/scsi/pmcraid.h          |    2 +-
 drivers/usb/serial/cypress_m8.c |    2 +-
 fs/ext4/move_extent.c           |    2 +-
 fs/fuse/inode.c                 |    2 +-
 fs/gfs2/ops_fstype.c            |    2 +-
 scripts/gfp-translate           |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/s390/kvm.txt b/Documentation/s390/kvm.txt
index 6f5ceb0..85f3280 100644
--- a/Documentation/s390/kvm.txt
+++ b/Documentation/s390/kvm.txt
@@ -102,7 +102,7 @@ args:		unsigned long
 see also:	include/linux/kvm.h
 This ioctl stores the state of the cpu at the guest real address given as
 argument, unless one of the following values defined in include/linux/kvm.h
-is given as arguement:
+is given as argument:
 KVM_S390_STORE_STATUS_NOADDR - the CPU stores its status to the save area in
 absolute lowcore as defined by the principles of operation
 KVM_S390_STORE_STATUS_PREFIXED - the CPU stores its status to the save area in
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 92f89d5..b8ad07c 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -938,7 +938,7 @@ static struct pmcraid_ioasc_error pmcraid_ioasc_error_table[] = {
 
 /*
  * pmcraid_ioctl_header - definition of header structure that preceeds all the
- * buffers given as ioctl arguements.
+ * buffers given as ioctl arguments.
  *
  * .signature           : always ASCII string, "PMCRAID"
  * .reserved            : not used
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index a591ebe..52a81a3 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -154,7 +154,7 @@ struct cypress_private {
 	int isthrottled;		   /* if throttled, discard reads */
 	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
-	/* we pass a pointer to this as the arguement sent to
+	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
 	struct ktermios tmp_termios; 	   /* stores the old termios settings */
 };
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 82c415b..12a9ec7 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -928,7 +928,7 @@ out2:
 }
 
 /**
- * mext_check_argumants - Check whether move extent can be done
+ * mext_check_arguments - Check whether move extent can be done
  *
  * @orig_inode:		original inode
  * @donor_inode:	donor inode
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1a822ce..ec14d19 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -850,7 +850,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->in.args[0].size = sizeof(*arg);
 	req->in.args[0].value = arg;
 	req->out.numargs = 1;
-	/* Variable length arguement used for backward compatibility
+	/* Variable length argument used for backward compatibility
 	   with interface version < 7.5.  Rest of init_out is zeroed
 	   by do_get_request(), so a short reply is not a problem */
 	req->out.argvar = 1;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index edfee24..0556f7f 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -992,7 +992,7 @@ static const struct lm_lockops nolock_ops = {
 /**
  * gfs2_lm_mount - mount a locking protocol
  * @sdp: the filesystem
- * @args: mount arguements
+ * @args: mount arguments
  * @silent: if 1, don't complain if the FS isn't a GFS2 fs
  *
  * Returns: errno
diff --git a/scripts/gfp-translate b/scripts/gfp-translate
index 073cb6d..d81b968 100644
--- a/scripts/gfp-translate
+++ b/scripts/gfp-translate
@@ -19,7 +19,7 @@ usage() {
 	exit 0
 }
 
-# Parse command-line arguements
+# Parse command-line arguments
 while [ $# -gt 0 ]; do
 	case $1 in
 		--source)
-- 
1.6.3.3

