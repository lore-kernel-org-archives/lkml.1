Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0BPBE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 20:04:29 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:29519 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab0BPBE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 20:04:28 -0500
Date: Mon, 15 Feb 2010 20:03:34 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for 2.6.33-rc
Message-ID: <20100216010334.GA18738@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B79EF12.0027:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is a late regression fix for btrfs fallocated extents.  We're
updating the wrong slot in the btree and that can lead to the wrong data
in the file:

Linus, please pull the master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Shaohua Li (1) commits (+4/-2):
    Btrfs: btrfs_mark_extent_written uses the wrong slot

Total: (1) commits

 fs/btrfs/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
