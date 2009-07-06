Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZGFPnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZGFPnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZGFPkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:40:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42427 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZGFPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:39:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 13/16] drbd: String constants
Date: Mon,  6 Jul 2009 17:39:32 +0200
Message-Id: <1246894775-10855-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1246894775-10855-13-git-send-email-philipp.reisner@linbit.com>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-2-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-3-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-4-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-5-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-6-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-7-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-8-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-9-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-10-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-11-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-12-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-13-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have that in a separate file, in so we can use a verbatim copy of this
file in the builds of the user space tools as well.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/drivers/block/drbd/drbd_strings.c b/drivers/block/drbd/drbd_strings.c
new file mode 100644
index 0000000..09922d2
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
+	[-SS_NO_LOCAL_DISK] = "Can not resync without local disk",
+	[-SS_NO_REMOTE_DISK] = "Can not resync without remote disk",
+	[-SS_CONNECTED_OUTDATES] = "Refusing to be Outdated while Connected",
+	[-SS_PRIMARY_NOP] = "Refusing to be Primary while peer is not outdated",
+	[-SS_RESYNC_RUNNING] = "Can not start OV/resync since it is already active",
+	[-SS_ALREADY_STANDALONE] = "Can not disconnect a StandAlone device",
+	[-SS_CW_FAILED_BY_PEER] = "State change was refused by peer node",
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
