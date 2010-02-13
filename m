Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0BMNmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:42:19 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:48992 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0BMNmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:42:16 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 08:42:16 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=bwYS8zdGTWUTgwNqxZSVFz7UIPkAipqFQgTJrAC1SmpGL68chJEo5Vdz+Dbxe+CxGr
         dRD8UuplP4Qf+BT5nXPEN7cMHPHR9Otut+EjFQo3X6YApfonKFMixxRX1i9vDhg7j4KA
         05gMPZ7kZV1DA1o6McGXrxynLM6CMRmfWn9IU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Sat, 13 Feb 2010 14:35:38 +0100
Message-Id: <20100213133538.11564.94218.sendpatchset@localhost>
Subject: [git patches] atang tree: fix UDMA mode for older Promise controllers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


DISCLAIMER: the fact of getting patches merged into atang tree means
that from now on they will be getting updates for changes happening
in atang tree and it should not be treated as an indication regarding
decisions taken by 'upstream' kernel trees


Russell King did some great debugging work last month on the root
source of UDMA problems that have been consistenly reported against
pata_pdc202xx_old driver for the last couple of years which should
allow us to hopefully fix them all in atang tree.


On top of atang-v4.4.

The following changes since commit bcf33ade797072b4dcd51dd13b353a6e052036c6:
  Thomas Chou (1):
        drivers/staging: New PATA driver for Altera CompactFlash.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.5

Bartlomiej Zolnierkiewicz (3):
      pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
      pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets
      pata_pdc202xx_old: update documentation

 drivers/ata/Kconfig             |    1 -
 drivers/ata/pata_pdc202xx_old.c |   13 ++++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)
