Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbZC3S3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbZC3S3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZC3SUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:20:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:53236 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbZC3SUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:20:09 -0400
Date: Mon, 30 Mar 2009 12:20:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] BKL-removal fixes
Message-ID: <20090330122005.33a5410f@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Here's a couple of bkl-removal fixes.  One clears up a lockdep warning
in the fasync work; the other adds a missing unlock_kernel() in an
error path.

  git://git.lwn.net/linux-2.6.git bkl-removal

Dan Carpenter (1):
      Add a missing unlock_kernel() in raw_open()

Jonathan Corbet (1):
      Fix a lockdep warning in fasync_helper()

 drivers/char/raw.c |    1 +
 fs/fcntl.c         |   10 +++++++---
 include/linux/fs.h |    2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

Thanks,

jon
