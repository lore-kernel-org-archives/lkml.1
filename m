Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbXCFMkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbXCFMkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXCFMkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:40:35 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44761 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbXCFMke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:40:34 -0500
Message-ID: <45ED6185.1000203@drzeus.cx>
Date: Tue, 06 Mar 2007 13:41:41 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC and NCP fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/mmc.c         |   83 ++++++++++++++----------
 drivers/mmc/sdhci.c       |   39 +++++++-----
 fs/ncpfs/inode.c          |   16 ++++-
 fs/ncpfs/sock.c           |  151 ++++++++++++++++++++++++++------------------
 include/linux/mmc/host.h  |    8 +++
 include/linux/ncp_fs_sb.h |    2 +
 6 files changed, 184 insertions(+), 115 deletions(-)

Mark Lord (1):
      sdhci: make isr tolerant of read errors

Pierre Ossman (3):
      ncpfs: make sure server connection survives a kill
      mmc: require explicit support for high-speed
      sdhci: release irq during suspend

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
