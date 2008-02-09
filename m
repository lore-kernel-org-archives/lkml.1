Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYBIJus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYBIJus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYBIJuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:50:39 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:54801 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYBIJui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:50:38 -0500
Date: Sat, 9 Feb 2008 10:50:34 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC updates
Message-ID: <20080209105034.0d64a239@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 MAINTAINERS                  |    3 -
 drivers/mmc/host/Kconfig     |    8 +-
 drivers/mmc/host/at91_mci.c  |  114 +++++++++++++++++++++---------
 drivers/mmc/host/ricoh_mmc.c |  162 ++++++++++++++++++++++++++++++++++-------
 drivers/mmc/host/sdhci.c     |   13 +++-
 drivers/mmc/host/sdhci.h     |    1 +
 6 files changed, 231 insertions(+), 70 deletions(-)

David Brownell (1):
      at91_mci: use generic GPIO calls

Feng Tang (1):
      sdhci: add num index for multi controllers case

Frank Seidel (1):
      mmc: extend ricoh_mmc to support Ricoh RL5c476

Philip Langdale (1):
      mmc: Handle suspend/resume in Ricoh MMC disabler

Pierre Ossman (2):
      mmc: remove sdhci and mmc_spi experimental markers
      MAINTAINERS: remove non-existant URLs



-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
