Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbZD3Lcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbZD3Lcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 07:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762532AbZD3L3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 07:29:15 -0400
Received: from [212.69.161.110] ([212.69.161.110]:38557 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762626AbZD3L2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 07:28:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 13/16] DRBD: misc
Date: Thu, 30 Apr 2009 13:26:49 +0200
Message-Id: <1241090812-13516-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1241090812-13516-13-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-6-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-7-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-8-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-9-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-10-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-11-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-12-git-send-email-philipp.reisner@linbit.com>
 <1241090812-13516-13-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buildtag.c tag will go away when we are not longer an external module.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/drivers/block/drbd/drbd_buildtag.c b/drivers/block/drbd/drbd_buildtag.c
new file mode 100644
index 0000000..a58ad76
--- /dev/null
+++ b/drivers/block/drbd/drbd_buildtag.c
@@ -0,0 +1,7 @@
+/* automatically generated. DO NOT EDIT. */
+#include <linux/drbd_config.h>
+const char *drbd_buildtag(void)
+{
+	return "GIT-hash: 29ef4c01e46b0a269d7bec39d5178be06097fead drbd/Kconfig drbd/Makefile drbd/Makefile-2.6 drbd/drbd_actlog.c drbd/drbd_bitmap.c drbd/drbd_int.h drbd/drbd_main.c drbd/drbd_nl.c drbd/drbd_proc.c drbd/drbd_receiver.c drbd/drbd_req.c drbd/drbd_req.h drbd/drbd_tracing.c drbd/drbd_tracing.h drbd/drbd_worker.c drbd/drbd_wrappers.h drbd/linux/drbd_config.h"
+		" build by phil@fat-tyre, 2009-04-29 15:43:41";
+}
diff --git a/drivers/block/drbd/drbd_strings.c b/drivers/block/drbd/drbd_strings.c
new file mode 100644
index 0000000..b230693
--- /dev/null
+++ b/drivers/block/drbd/drbd_strings.c
@@ -0,0 +1,113 @@
+/*
+  drbd.h
+
+  This file is part of DRBD by Philipp Reisner and Lars Ellenberg.
+
+  Copyright (C) 2003-2008, LINBIT Information Technologies GmbH.
+  Copyright (C) 2003-2008, Philipp Reisner <philipp.reisner@linbit.com>.
+  Copyright (C) 2003-2008, Lars Ellenberg <lars.ellenberg@linbit.com>.
+
+  drbd is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2, or (at your option)
+  any later version.
+
+  drbd is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with drbd; see the file COPYING.  If not, write to
+  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#include <linux/drbd.h>
+
+static const char *drbd_conn_s_names[] = {
+	[C_STANDALONE]       = "StandAlone",
+	[C_DISCONNECTING]    = "Disconnecting",
+	[C_UNCONNECTED]      = "Unconnected",
+	[C_TIMEOUT]          = "Timeout",
+	[C_BROKEN_PIPE]      = "BrokenPipe",
+	[C_NETWORK_FAILURE]  = "NetworkFailure",
+	[C_PROTOCOL_ERROR]   = "ProtocolError",
+	[C_WF_CONNECTION]    = "WFConnection",
+	[C_WF_REPORT_PARAMS] = "WFReportParams",
+	[C_TEAR_DOWN]        = "TearDown",
+	[C_CONNECTED]        = "Connected",
+	[C_STARTING_SYNC_S]  = "StartingSyncS",
+	[C_STARTING_SYNC_T]  = "StartingSyncT",
+	[C_WF_BITMAP_S]      = "WFBitMapS",
+	[C_WF_BITMAP_T]      = "WFBitMapT",
+	[C_WF_SYNC_UUID]     = "WFSyncUUID",
+	[C_SYNC_SOURCE]      = "SyncSource",
+	[C_SYNC_TARGET]      = "SyncTarget",
+	[C_PAUSED_SYNC_S]    = "PausedSyncS",
+	[C_PAUSED_SYNC_T]    = "PausedSyncT",
+	[C_VERIFY_S]         = "VerifyS",
+	[C_VERIFY_T]         = "VerifyT",
+};
+
+static const char *drbd_role_s_names[] = {
+	[R_PRIMARY]   = "Primary",
+	[R_SECONDARY] = "Secondary",
+	[R_UNKNOWN]   = "Unknown"
+};
+
+static const char *drbd_disk_s_names[] = {
+	[D_DISKLESS]     = "Diskless",
+	[D_ATTACHING]    = "Attaching",
+	[D_FAILED]       = "Failed",
+	[D_NEGOTIATING]  = "Negotiating",
+	[D_INCONSISTENT] = "Inconsistent",
+	[D_OUTDATED]     = "Outdated",
+	[D_UNKNOWN]      = "DUnknown",
+	[D_CONSISTENT]   = "Consistent",
+	[D_UP_TO_DATE]   = "UpToDate",
+};
+
+static const char *drbd_state_sw_errors[] = {
+	[-SS_TWO_PRIMARIES] = "Multiple primaries not allowed by config",
+	[-SS_NO_UP_TO_DATE_DISK] = "Refusing to be Primary without at least one UpToDate disk",
+	[-SS_BOTH_INCONSISTENT] = "Refusing to be inconsistent on both nodes",
+	[-SS_SYNCING_DISKLESS] = "Refusing to be syncing and diskless",
+	[-SS_CONNECTED_OUTDATES] = "Refusing to be Outdated while Connected",
+	[-SS_PRIMARY_NOP] = "Refusing to be Primary while peer is not outdated",
+	[-SS_RESYNC_RUNNING] = "Can not start OV/resync since it is already active",
+	[-SS_ALREADY_STANDALONE] = "Can not disconnect a StandAlone device",
+	[-SS_CW_FAILED_BY_PEER] = "State changed was refused by peer node",
+	[-SS_IS_DISKLESS] = "Device is diskless, the requesed operation requires a disk",
+	[-SS_DEVICE_IN_USE] = "Device is held open by someone",
+	[-SS_NO_NET_CONFIG] = "Have no net/connection configuration",
+	[-SS_NO_VERIFY_ALG] = "Need a verify algorithm to start online verify",
+	[-SS_NEED_CONNECTION] = "Need a connection to start verify or resync",
+	[-SS_NOT_SUPPORTED] = "Peer does not support protocol",
+	[-SS_LOWER_THAN_OUTDATED] = "Disk state is lower than outdated",
+	[-SS_IN_TRANSIENT_STATE] = "In transient state, retry after next state change",
+	[-SS_CONCURRENT_ST_CHG] = "Concurrent state changes detected and aborted",
+};
+
+const char *conns_to_name(enum drbd_conns s)
+{
+	/* enums are unsigned... */
+	return s > C_PAUSED_SYNC_T ? "TOO_LARGE" : drbd_conn_s_names[s];
+}
+
+const char *roles_to_name(enum drbd_role s)
+{
+	return s > R_SECONDARY   ? "TOO_LARGE" : drbd_role_s_names[s];
+}
+
+const char *disks_to_name(enum drbd_disk_state s)
+{
+	return s > D_UP_TO_DATE    ? "TOO_LARGE" : drbd_disk_s_names[s];
+}
+
+const char *set_st_err_name(enum drbd_state_ret_codes err)
+{
+	return err <= SS_AFTER_LAST_ERROR ? "TOO_SMALL" :
+	       err > SS_TWO_PRIMARIES ? "TOO_LARGE"
+			: drbd_state_sw_errors[-err];
+}
