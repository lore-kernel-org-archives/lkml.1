Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYEGWwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYEGWwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYEGWvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:51:49 -0400
Received: from cobra.newdream.net ([66.33.216.30]:51232 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbYEGWvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:51:48 -0400
X-Greylist: delayed 1128 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 18:51:48 EDT
Date: Wed, 7 May 2008 15:32:57 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: [ANNOUNCE] Ceph distributed file system v0.2
Message-ID: <Pine.LNX.4.64.0804291419280.15314@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Ceph is a distributed file system designed for performance, reliability, 
and scalability.  Basic features include:

 * POSIX semantics
 * Seamless scaling from 1 to many thousands of nodes
 * No single point of failure
 * N-way replication of data across storage nodes
 * Fast recovery from node failures
 * Automatic rebalancing of data on node addition/removal
 * Easy deployment: most FS components are userspace daemons
 * Linux kernel client, FUSE-based client, and user library

Notable in this release is a reasonably stable Linux kernel client.  It 
can extract and compile a kernel, and passes all tests in the fstest POSIX 
regression test suite posted a few weeks back.  It has stabilized to the 
point where it could use some broader testing and code review.

More info at

	http://ceph.newdream.net

Source code at

	git://ceph.newdream.net/ceph.git
	http://ceph.newdream.net/git

Since v0.1:

 * fully functional (and reasonably stable) kernel client
 * NFS re-export of a ceph client mount
 * client metadata leases to keep client cache coherent 
 * crushtool for managing storage cluster topology
 * improved support for storage cluster expansion
 * some new tools for mkfs and management
 * lots and lots of bug fixes...

Planned for v0.3:

 * xattrs
 * hardening distributed failure recovery
 * large directory support (in client)
 * recursive mtime and file size accounting

Some key things on the (medium- to long-term) roadmap:

 * locks
 * quotas
 * btrfs for local object storage on storage nodes
 * directory-granularity snapshots
 * content-addressible storage
 * strong security

sage
