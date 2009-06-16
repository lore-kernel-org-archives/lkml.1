Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZFPBBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZFPBBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 21:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZFPBA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 21:00:56 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:65100 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZFPBA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 21:00:56 -0400
Date: Mon, 15 Jun 2009 21:00:45 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs bug fix
Message-ID: <20090616010045.GB3735@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.4A36EEBF.0095:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a fix for the new space balancing code (btrfs-vol -b).  The bug can
trigger a corruption if you run the balancing with multiple subvolumes
and unmount without doing anything in the subvolumes.

Yan Zheng (1) commits (+6/-6):
    Btrfs: always update root items for fs trees at commit time

Total: (1) commits

 fs/btrfs/transaction.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

