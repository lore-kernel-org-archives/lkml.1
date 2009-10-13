Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbZJMJ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbZJMJ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZJMJ24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:28:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52223 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZJMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:28:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 0/7] SECURITY ISSUE with connector for 2.6.31.y
Date: Tue, 13 Oct 2009 11:28:11 +0200
Message-Id: <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20091009222505.GA28979@kroah.com>
References: <20091009222505.GA28979@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backported edition of the patchset for 2.6.31-stable.

Philipp Reisner (7):
  connector: Keep the skb in cn_callback_data
  connector: Provide the sender's credentials to the callback
  connector: Removed the destruct_data callback since it is always
    kfree_skb()
  dm/connector: Only process connector packages from privileged
    processes
  dst/connector: Disallow unpliviged users to configure dst
  pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
  uvesafb/connector: Disallow unpliviged users to send netlink packets

 Documentation/connector/cn_test.c      |    4 +---
 Documentation/connector/connector.txt  |    8 ++++----
 drivers/connector/cn_proc.c            |    3 +--
 drivers/connector/cn_queue.c           |   15 ++++++++++-----
 drivers/connector/connector.c          |   24 +++++++++---------------
 drivers/md/dm-log-userspace-transfer.c |    6 ++++--
 drivers/staging/dst/dcore.c            |    8 ++++++--
 drivers/staging/pohmelfs/config.c      |    6 ++++--
 drivers/video/uvesafb.c                |    6 ++++--
 drivers/w1/w1_netlink.c                |    3 +--
 include/linux/connector.h              |   11 ++++-------
 11 files changed, 48 insertions(+), 46 deletions(-)

