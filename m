Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbYLLFVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbYLLFVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYLLFVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:21:25 -0500
Received: from sh.osrg.net ([192.16.179.4]:37935 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYLLFVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:21:24 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH mmotm 0/5] nilfs2 filesystem updates
Date: Fri, 12 Dec 2008 14:16:56 +0900
Message-Id: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set to update nilfs2 filesystem in mmotm (applicable
to mmotm-2008-Dec-12).

The following bugfix and changes which follow comments offered in the
previous submission:

* fix problems around nilfs2 ioctl which may cause system memory shortage.
* avoid double error handlings brought by nilfs_transaction_end() by
  separating nilfs_transaction_abort() function.
* insert description of gcinode in the source file.
* add a maintainer entry of nilfs2 to the MAINTAINERS file (to apply as
  needed).

Regards,
Ryusuke Konishi
---

 MAINTAINERS           |    7 ++++
 fs/nilfs2/gcinode.c   |   21 +++++++++++++-
 fs/nilfs2/inode.c     |   23 +++++++++------
 fs/nilfs2/ioctl.c     |   75 ++++++++++++++++++++++++++++++-------------------
 fs/nilfs2/mdt.c       |    5 ++-
 fs/nilfs2/namei.c     |   74 +++++++++++++++++++++++++++++++++---------------
 fs/nilfs2/nilfs.h     |    3 +-
 fs/nilfs2/segment.c   |   43 ++++++++++++++++++----------
 fs/nilfs2/super.c     |   11 +------
 fs/nilfs2/the_nilfs.h |    4 +-
 10 files changed, 175 insertions(+), 91 deletions(-)


