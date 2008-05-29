Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYE2Pqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYE2Pqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYE2PqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:46:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30945 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYE2PqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:46:14 -0400
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Btrfs v0.15 released
Content-Disposition: inline
From: Chris Mason <chris.mason@oracle.com>
Date: Thu, 29 May 2008 11:45:30 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200805291145.30535.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Btrfs v0.15 is now available for download.  The major feature added over v0.14 
is the ability to remove devices online, and improved handling of IO failures 
during reads and writes.  v0.15 does not include any disk format changes over 
v0.14.

You can find btrfs download information and documentation at:

http://btrfs.wiki.kernel.org/

Another highlight is the clone file data ioctl from Sage Weil, which can be 
used to make a COW copy of a single file.  btrfs-progs includes a new command 
called bcp which can be used to run COW copies on single files or directory 
trees.

Summary of fixes since v0.14

* 2.6.26-rc compile fixes (Mingming Cao)
* Fixes for IO stalls and high CPU usage during huge streaming writes (thanks 
to Eric Whitney for testing these on 14TB files)
* Online device removal and degraded mounts
* Fixes to the online extent relocation and balancing code
* Deal with devices disappearing after initial btrfsctl -a scan
* Transparently correct IO errors on raid1 and raid10 by using the other 
mirror.
* Detect misplaced btree writes by checking generation numbers during reads
* Fix nodatacow to more accurately detect snapshots
* Compile fixes for Apparmor kernels (Jeff Mahoney)
* Clone file data ioctl (Sage Weil)
* Fixes and optimizations for 2.6.18 enterprise kernels

-chris
