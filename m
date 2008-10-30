Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYJ3FhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYJ3FhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYJ3FgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:36:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47220 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYJ3FgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:36:18 -0400
Date: Wed, 29 Oct 2008 22:35:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, scsi <linux-scsi@vger.kernel.org>,
       jejb <James.Bottomley@hansenpartnership.com>, Eric.Moore@lsi.com
Subject: [PATCH 7/7] fusion: remove excess kernel-doc notation
Message-Id: <20081029223516.18de2e9d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc function parameter notation:

Warning(drivers/message/fusion/mptbase.c:964): Excess function parameter or struct member 'handle' description in 'mpt_free_msg_frame'
Warning(drivers/message/fusion/mptbase.c:5434): Excess function parameter or struct member 'portnum' description in 'mpt_findImVolumes'
Warning(drivers/message/fusion/mptbase.c:6949): Excess function parameter or struct member 'mr' description in 'mpt_spi_log_info'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Eric.Moore@lsi.com
---
 drivers/message/fusion/mptbase.c |    3 ---
 1 file changed, 3 deletions(-)

--- lin2628-rc2.orig/drivers/message/fusion/mptbase.c
+++ lin2628-rc2/drivers/message/fusion/mptbase.c
@@ -952,7 +952,6 @@ mpt_put_msg_frame_hi_pri(u8 cb_idx, MPT_
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_free_msg_frame - Place MPT request frame back on FreeQ.
- *	@handle: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
@@ -5422,7 +5421,6 @@ mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc,
 /**
  *	mpt_findImVolumes - Identify IDs of hidden disks and RAID Volumes
  *	@ioc: Pointer to a Adapter Strucutre
- *	@portnum: IOC port number
  *
  *	Return:
  *	0 on success
@@ -6939,7 +6937,6 @@ mpt_fc_log_info(MPT_ADAPTER *ioc, u32 lo
 /**
  *	mpt_spi_log_info - Log information returned from SCSI Parallel IOC.
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@mr: Pointer to MPT reply frame
  *	@log_info: U32 LogInfo word from the IOC
  *
  *	Refer to lsi/sp_log.h.
