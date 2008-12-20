Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYLTW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYLTW7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 17:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYLTW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 17:59:23 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:35266 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751799AbYLTW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 17:59:22 -0500
X-YMail-OSG: ZYi5U9MVM1mWiNrBJwVDtJjQwNZaGCcAPAdgak0FbIMPffiuiuvC_k4N5w7N1EqtmbMst9oQk84tYpBUx7x27I5XKDGC8hzRsWk_21VlcUJeeR2Ri_EyEHFSrH6XtdL3Vb74kXSZpman1WRIvJWLxoY20yO2QanM1tQN.3bpKY646QInDv6_SvJ4UTxwRinQZt0oQssc0RCYRgz7KO0PGuFCsFfzFOM-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/8] [Target_Core_Mod/LIO-Target] v3.0 updates and bugfixes
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 14:58:51 -0800
Message-Id: <1229813931.4560.191.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

Just a few updates and bugfixes for the generic engine and LIO-Target as
LIO-Target is being brought online using the v3.0 generic target core
infrastructure.  They are made against against lio-core-2.6.git/master
and tested on v2.6.28-rc7.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

 drivers/lio-core/iscsi_target.c           |   22 +++--
 drivers/lio-core/iscsi_target_configfs.c  |    2 -
 drivers/lio-core/iscsi_target_login.c     |    5 +-
 drivers/lio-core/iscsi_target_tpg.c       |   43 -----------
 drivers/lio-core/iscsi_target_tpg.h       |    2 -
 drivers/lio-core/target_core_fabric_ops.h |    5 -
 drivers/lio-core/target_core_tpg.c        |  115 +++++++++++++++--------------
 drivers/lio-core/target_core_transport.c  |   19 +----
 drivers/lio-core/target_core_transport.h  |    3 +-
 9 files changed, 78 insertions(+), 138 deletions(-)

[PATCH 1/8] [Target_Core_Mod]: Add EXPORT_SYMBOL() to transport_release_cmd_to_pool()
[PATCH 2/8] [LIO-Target]: Properly release se_cmd_t w/ CHECK_CONDITION exception during iSCSI session recovery
[PATCH 3/8] [Target_Core_Mod/LIO-Target]: Rename and update usage of transport_allocate_session()
[PATCH 4/8] [Target_Core_Mod]: Add transport_free_session()
[PATCH 5/8] [LIO-Target]: Add transport_free_session() in iscsi_target_login_thread() exception path
[PATCH 6/8] [Target_Core_Mod]: Reenable core_tpg_del_initiator_node_acl() and core_tpg_set_initiator_node_queue_depth()
[PATCH 7/8] [LIO-Target/ConfigFS]: Add lio_tpg_shutdown_session() and lio_tpg_close_session()
[PATCH 8/8] [LIO-Target]: Fix leakage of ISCSI_INIT_LOGOUT_CMND for CLOSESESSION or same CID CLOSECONNECTION cases

--nab

