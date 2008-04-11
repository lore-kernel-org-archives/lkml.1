Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYDKTpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYDKTpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYDKTp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:45:29 -0400
Received: from vena.lwn.net ([206.168.112.25]:42726 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbYDKTp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:45:28 -0400
To: torvalds@linux-foundation.org
Subject: [PULL] Current documentation tree
cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
From: Jonathan Corbet <corbet@lwn.net>
Date: Fri, 11 Apr 2008 13:45:27 -0600
Message-ID: <22660.1207943127@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a current version of the documentation tree at:

  git://git.lwn.net/linux-2.6.git docs

There are a couple of code comment changes, but no changes to any code
itself.  It's safe to pull now (and it would be nice to get a couple of
these changes in), but can also easily wait for the merge window to
open.

What's there:

J. Bruce Fields (4):
      Spell out behavior of atomic_dec_and_lock() in kerneldoc
      Documentation: move nfsroot.txt to filesystems/
      Documentation: move rpc-cache.txt to filesystems/
      Move sched-rt-group.txt to scheduler/

Jan Engelhardt (1):
      Fixes to the seq_file document

Jonathan Corbet (2):
      Add the seq_file documentation
      Fill out information on patch tags in SubmittingPatches

Mark Fasheh (1):
      Add additional examples in Documentation/spinlocks.txt

Will Newton (1):
      Fix a typo in highres.txt

 Documentation/00-INDEX                           |    4 -
 Documentation/SubmittingPatches                  |   54 ++++-
 Documentation/filesystems/00-INDEX               |    6 +
 Documentation/{ => filesystems}/nfsroot.txt      |    0 
 Documentation/{ => filesystems}/rpc-cache.txt    |    0 
 Documentation/filesystems/seq_file.txt           |  283 ++++++++++++++++++++++
 Documentation/hrtimers/highres.txt               |    2 +-
 Documentation/kernel-parameters.txt              |    6 +-
 Documentation/scheduler/00-INDEX                 |    2 +
 Documentation/{ => scheduler}/sched-rt-group.txt |    0 
 Documentation/spinlocks.txt                      |   22 ++
 fs/Kconfig                                       |    8 +-
 include/linux/spinlock.h                         |    3 +
 net/ipv4/Kconfig                                 |    8 +-
 net/ipv4/ipconfig.c                              |    2 +-
 15 files changed, 380 insertions(+), 20 deletions(-)
 rename Documentation/{ => filesystems}/nfsroot.txt (100%)
 rename Documentation/{ => filesystems}/rpc-cache.txt (100%)
 create mode 100644 Documentation/filesystems/seq_file.txt
 rename Documentation/{ => scheduler}/sched-rt-group.txt (100%)

jon
