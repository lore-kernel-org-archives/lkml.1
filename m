Return-Path: <linux-kernel-owner+w=401wt.eu-S1422863AbXD3DOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422863AbXD3DOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422854AbXD3DOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:14:09 -0400
Received: from imf07aec.mail.bellsouth.net ([205.152.59.55]:33213 "EHLO
	imf07aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422824AbXD3DOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:14:07 -0400
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Apr 2007 23:14:06 EDT
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: [PATCH 0/2] atl1: minor cleanup
Date: Sun, 29 Apr 2007 21:42:09 -0500
Message-Id: <11779009311121-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please accept the following trivial patches to the atl1 driver.

- use dev_printk macros
- fix whitespace damage

 drivers/net/atl1/atl1_ethtool.c |   19 +++------
 drivers/net/atl1/atl1_hw.c      |   44 ++++++++++-----------
 drivers/net/atl1/atl1_main.c    |   83 +++++++++++++++++---------------------
 drivers/net/atl1/atl1_param.c   |   31 +++++++--------
 4 files changed, 79 insertions(+), 98 deletions(-)
