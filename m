Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYC1SUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYC1SUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYC1SUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:20:15 -0400
Received: from vena.lwn.net ([206.168.112.25]:41308 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbYC1SUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:20:14 -0400
To: linux-kernel@vger.kernel.org
Subject: [Pull] Some documentation patches
cc: torvalds@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>
From: Jonathan Corbet <corbet@lwn.net>
Date: Fri, 28 Mar 2008 12:20:12 -0600
Message-ID: <13387.1206728412@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that getting documentation patches merged seems to be a
slower and more uncertain process than it was a while back.  So I
figured I'd try to be one of the cool folks with their own git tree and
see if that works better.  Linus, if you agree, could you please pull:

  git://git.lwn.net/linux-2.6.git docs

To get the following:

Jonathan Corbet (3):
      Add the seq_file documentation
      Fill out information on patch tags in SubmittingPatches
      Add a comment discouraging use of in_atomic()

 Documentation/SubmittingPatches        |   54 ++++++-
 Documentation/filesystems/00-INDEX     |    2 +
 Documentation/filesystems/seq_file.txt |  283 ++++++++++++++++++++++++++++++++
 include/linux/hardirq.h                |    8 +
 4 files changed, 344 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/filesystems/seq_file.txt

These changes are (1) an updated version of the seq_file document first
posted in 2003, (2) the much-reviewed patch tags documentation, and
(3) a comment warning developers that in_atomic() doesn't mean what they
think it means.  No code changes.

If this works out, and nobody objects, I'll try to run this tree into
the future as a collection point for documentation patches which don't
have a more obvious tree to travel through.

Thanks,

jon
