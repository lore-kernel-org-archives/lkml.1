Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbXH1KxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbXH1KxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXH1Kw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:52:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:46819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXH1Kw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:52:57 -0400
Date: Tue, 28 Aug 2007 10:52:52 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Linux 2.6.20.18
Message-ID: <20070828105252.GA17747@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.20.18. It reverts two patches that
should not have been backported and which broke the build for at
least two persons. It also contains another confirmed fix from
2.6.22 for a problem reported in 2.6.20.17 by Michal Piotrowski.

This release is intended as a cleanup of 2.6.20.17, that's why it is so
small. BTW, 2.6.22-stable seems to be calming down. I will probably
release another 2.6.20.x later if some patches are relevant, and it
may be the last one if the patch rate in 2.6.22 stays low.

I'll also be replying to this message with a copy of the patch between
2.6.20.17 and 2.6.20.18.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.18.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.18

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git

Willy

-------

 Makefile                       |    2 +-
 drivers/ata/pata_atiixp.c      |    1 -
 include/net/bluetooth/rfcomm.h |    1 -
 net/bluetooth/rfcomm/tty.c     |   30 ++++++++----------------------
 net/core/skbuff.c              |    2 +-
 5 files changed, 10 insertions(+), 26 deletions(-)

Summary of changes from 2.6.20.17 to 2.6.20.18
============================================

Patrick McHardy (1):
      Fix incorrect config #ifdef around skb_copy_secmark

Willy Tarreau (3):
      Revert "Keep rfcomm_dev on the list until it is freed"
      Revert "pata_atiixp: add SB700 PCI ID"
      Linux 2.6.20.18

