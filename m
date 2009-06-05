Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZFERtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZFERtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZFERtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:49:12 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:34622 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFERtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:49:12 -0400
Date: Fri, 5 Jun 2009 13:48:59 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes for 2.6.30-rc
Message-ID: <20090605174859.GA3824@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A295A8D.0294:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

These fix two bugs we found this week, and they can lead to oopsen when
using the btrfs device management ioctls (adding/removing/balancing
space across drives).

Linus, please pull from the master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Chris Mason (1) commits (+48/-3):
    Btrfs: Fix oops and use after free during space balancing

Yan Zheng (1) commits (+1/-0):
    Btrfs: set device->total_disk_bytes when adding new device

Total: (2) commits

 fs/btrfs/extent-tree.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c     |    1 

-chris
