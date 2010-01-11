Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142Ab0AKUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0AKUQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019Ab0AKUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:16:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59703 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0AKUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:16:29 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 0/7] General sysfs enhancements
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 12:16:09 -0800
Message-ID: <m1d41g9z3q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is built on top of 2.6.33-rc3 +
  "sysfs: Cache the last sysfs_dirent to improve readdir scalability v2"

Greg I assume you have that patch somewhere in queue.

This patchset contains little cleanups all around sysfs.
- Some basic cleanups.
- Some sysfs scaling work 
- Implementation of sysfs_rename

 drivers/base/core.c   |   18 ++++++------------
 fs/sysfs/dir.c        |   22 +++++++++++++++++++++-
 fs/sysfs/inode.c      |   28 ++++++++--------------------
 fs/sysfs/mount.c      |    5 ++---
 fs/sysfs/symlink.c    |   38 ++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h      |    6 +++---
 include/linux/sysfs.h |    9 +++++++++
 7 files changed, 87 insertions(+), 39 deletions(-)

This should be the final patchset before we can seriously look at
network namespace support in sysfs, again.

Eric
