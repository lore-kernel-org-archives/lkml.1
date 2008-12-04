Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYLDEe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYLDEe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYLDEes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:34:48 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:42626 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751713AbYLDEer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:34:47 -0500
X-YMail-OSG: fpt8MiEVM1lK7jdAPf.tjRLBMq7mWUcAPkO4Od06PVxdi8wCbebDSEZbekTCizcZpYxuQFfCeHD0FPUX0us.ncZXBbA13SNoIMBeX6FINS30mhMCQBfh6Om1zfrOz1kTBZkBOQzyh90q40cNmT7.xCUaGi33QnzJS8ua_MA533ltYHBUkv9H7LGzqM4-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/3] Add ConfigFS enabled write_protect support to
	LIO-Target
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 20:34:44 -0800
Message-Id: <1228365284.4153.105.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This patch series adds support for turning on LUN level SCSI WRITE-Protect
for iSCSI Target Portal Groups (TPGs) and iSCSI Initiator LUN ACLs in
the Linux-iSCSI.org Target (LIO-Target).  They are made against against
lio-core-2.6.git/master and tested on v2.6.28-rc7.

[PATCH 1/3] [LIO-Target]: Update for iSCSI Initiator LUN ACLs using write_protect
[PATCH 2/3] [LIO-Target]: Add TPG attributes demo_mode_write_protect and prod_mode_write_protect
[PATCH 3/3] [LIO-Target/ConfigFS]: Add Target Portal Group *_write_protect attributes and iSCSI LUN ACL write_protect bit

The lio-core-2.6.git is located at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Comments are appericated,

--nab

