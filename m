Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZLTDhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZLTDhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 22:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZLTDh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 22:37:29 -0500
Received: from mail.perches.com ([173.55.12.10]:1299 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZLTDh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 22:37:28 -0500
From: Joe Perches <joe@perches.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] cciss: printk cleanups
Date: Sat, 19 Dec 2009 19:37:24 -0800
Message-Id: <cover.1261279381.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup printk uses

Joe Perches (2):
  drivers/block/cciss: Convert printk(KERN_<level> to pr_<level>(
  drivers/block/cciss: Create and use cciss_debug functions, use
    pr_info

 drivers/block/cciss.c      |  424 ++++++++++++++++++-------------------------
 drivers/block/cciss_scsi.c |  340 +++++++++++++++---------------------
 2 files changed, 319 insertions(+), 445 deletions(-)

