Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZCIQEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZCIQEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZCIQEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:04:44 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:45797 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZCIQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:04:43 -0400
Subject: [GIT PULL] Btrfs update for 2.6.29-rc
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 12:03:54 -0400
Message-Id: <1236614634.9930.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49B53DF0.00A0:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Has a fix for Btrfs compiled in UP mode, getting rid of a spin_is_locked
check

Chris Mason (1):
      Btrfs: fix spinlock assertions on UP systems

 ctree.c       |   10 +++++-----
 disk-io.c     |    4 ++--
 extent-tree.c |    4 ++--
 locking.c     |    6 +++---
 locking.h     |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

-chris


