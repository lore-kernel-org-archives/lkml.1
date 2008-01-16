Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYAPXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYAPXNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYAPXNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:13:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYAPXNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=jFh7PWX/KE5BYrZHLKJf+o37QwC8aX0h8Bns0BujA6fFX9N3smRC/YsupbzFVvnWk0IWmEEiuIRn/7Eo5YxZShYteRejAYv+LQsRuC6pNRjCEOvWPGADiG58V3Jww32Gg0vC3+j6aGax4+PrKKYIFB0v4zARrrRC0E+YaCsO3Fg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:25:56 +0100
Message-Id: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/22] ide: even more IDE probing code rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just another bunch of small fixes/cleanups...

diffstat:

 drivers/ide/arm/bast-ide.c        |   22 +++-
 drivers/ide/arm/rapide.c          |    4
 drivers/ide/ide-acpi.c            |   60 +++--------
 drivers/ide/ide-pnp.c             |    9 -
 drivers/ide/ide-probe.c           |  204 +++++++++++++++++++++-----------------
 drivers/ide/ide-proc.c            |    7 -
 drivers/ide/ide.c                 |   66 +++++++-----
 drivers/ide/legacy/dtc2278.c      |   10 -
 drivers/ide/legacy/ht6560b.c      |   26 ++--
 drivers/ide/legacy/ide-cs.c       |   31 +++++
 drivers/ide/legacy/ide_platform.c |    4
 drivers/ide/legacy/qd65xx.c       |   44 ++++++--
 drivers/ide/mips/au1xxx-ide.c     |    7 -
 drivers/ide/pci/delkin_cb.c       |   40 +++++--
 drivers/ide/pci/opti621.c         |   10 +
 drivers/ide/pci/rz1000.c          |    3
 drivers/ide/pci/scc_pata.c        |    4
 drivers/macintosh/mediabay.c      |    2
 include/linux/ide.h               |   22 ++--
 19 files changed, 340 insertions(+), 235 deletions(-)
