Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYH1EK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYH1EK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 00:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYH1EJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 00:09:55 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:29421 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755185AbYH1EJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 00:09:54 -0400
Date: Wed, 27 Aug 2008 21:21:56 -0700
From: Karen Xie <kxie@chelsio.com>
Message-Id: <200808280421.m7S4LuUp006452@localhost.localdomain>
To: netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 2.6.28] cxgb3i iscsi initiator driver
Cc: jgarzik@pobox.com, davem@davemloft.net, michaelc@cs.wisc.edu,
       swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com,
       leedom@chelsio.com, kxie@chelsio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone,

Please review our new version of the iSCSI Initiator drivers for Chelsio S3 adapters. We have updated the code with the feedbacks received, including getting rid of most of the __GFP_NOFAIL allocation.

The cxgb3i driver provides iscsi acceleration (PDU digest offload and payload direct-placement) to the open-iscsi initiator. It accesses the hardware through the cxgb3 module.

The accelerated iscsi traffic uses a private IP address which is unknown to the OS.

netdev list, please review part 1, 2 and cxgb3i_offload.[ch] in part 4 which handle the iscsi connection APIs to the adapter.

Thanks.
Karen
