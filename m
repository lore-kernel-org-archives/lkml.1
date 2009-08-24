Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZHXQBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZHXQBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZHXQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:01:43 -0400
Received: from relais.videotron.ca ([24.201.245.36]:35752 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZHXQBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:01:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 24 Aug 2009 12:01:38 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: git pull request: small Orion/Kirkwood fixes for 2.6.31-rc
Message-id: <alpine.LFD.2.00.0908241157210.6044@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Since RMK is on vacation, could you please pull the following:

	git://git.marvell.com/orion fixes

This is based on v2.6.31-rc7 and contains 3 small fixes as follows:

John Holland (1):
      [ARM] Kirkwood: enable eSATA on QNAP TS-219P

Martin Michlmayr (1):
      [ARM] Kirkwood: __init requires linux/init.h

Simon Kagstrom (1):
      [ARM] Orion NAND: Make asm volatile avoid GCC pushing ldrd out of the loop

 arch/arm/configs/kirkwood_defconfig     |    2 +-
 arch/arm/mach-kirkwood/ts219-setup.c    |    9 +++++++++
 arch/arm/plat-orion/include/plat/gpio.h |    2 ++
 drivers/mtd/nand/orion_nand.c           |    2 +-
 4 files changed, 13 insertions(+), 2 deletions(-)


Nicolas
