Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYHVSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYHVSc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbYHVSb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:31:57 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:23173 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757851AbYHVSbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:31:55 -0400
Date: Fri, 22 Aug 2008 11:37:10 -0700
From: Karen Xie <kxie@chelsio.com>
Message-Id: <200808221837.m7MIbAvv004384@localhost.localdomain>
To: netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 2.6.28] cxgb3i - Add iSCSI driver
Cc: jgarzik@pobox.com, davem@davemloft.net, michaelc@cs.wisc.edu,
       swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com,
       leedom@chelsio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone,

Please review our new version of the iSCSI Initiator drivers for Chelsio S3 adapters. The cxgb3i driver provides iscsi acceleration (PDU digest offload and payload direct-placement) to the open-iscsi initiator. It accesses the hardware through the cxgb3 module.

The accelerated iscsi traffic uses a private IP address which is unknown to the OS.

netdev list, please review part 1, 2 and cxgb3i_offload.[ch] in part 4 which handle the iscsi connection APIs to the adapter.

Thanks.
Karen
