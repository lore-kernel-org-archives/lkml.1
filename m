Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbYLDJjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbYLDJjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYLDJjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:39:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58467 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbYLDJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:39:06 -0500
Date: Thu, 4 Dec 2008 09:39:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] bdev misc fixes for .28-final
Message-ID: <20081204093904.GI28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is basically a sweeping-up after bdev API series merge -
two bug fixes and cleaning up bits of detritus.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/bdev.git/ for-linus

Shortlog:
Al Viro (2):
      kill obsolete temporary comment in swsusp_close()
      fix bogus argument of blkdev_put() in pktcdvd

Andreas Schwab (1):
      Fix block dev compat ioctl handling

Christoph Hellwig (3):
      clean up blkdev_get a little bit
      kill FMODE_NDELAY_NOW
      documnt FMODE_ constants

Diffstat:
 block/compat_ioctl.c    |   31 ++++++++++++++++++++++++++++++-
 drivers/block/pktcdvd.c |    4 ++--
 drivers/scsi/sd.c       |    2 +-
 drivers/scsi/sr.c       |    2 +-
 fs/block_dev.c          |   21 ++++++++++++++++-----
 include/linux/fs.h      |   33 +++++++++++++++++----------------
 kernel/power/swap.c     |    2 +-
 7 files changed, 68 insertions(+), 27 deletions(-)

