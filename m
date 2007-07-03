Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbXGCAhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbXGCAhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbXGCAh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:37:27 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:45190 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbXGCAh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:37:26 -0400
X-IronPort-AV: i="4.16,489,1175486400"; 
   d="scan'208"; a="44198055:sNHT30483838"
Subject: [GIT PULL] Blackfin arch fixes (try #2)
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 03 Jul 2007 08:37:21 +0800
Message-Id: <1183423041.10353.8.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 03 Jul 2007 00:37:24.0886 (UTC) FILETIME=[5356AB60:01C7BD0A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Marco's patch will kill the zero file git-pull error.
Jie's patch is required because we will release our new Blackfin toolchain.

Please pull from "master" branch of:

  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/ master

Jie Zhang (1):
      Blackfin arch: Add proper -mcpu option according to the cpu and silicon revision configuration

Marco Roeland (1):
      Blackfin arch: remove zero-sized include/asm-blackfin/macros.h

Mike Frysinger (1):
      Blackfin arch: update board defconfig files

Robin Getz (1):
      Blackfin arch: Fix up remaining printks with proper log levels

 arch/blackfin/Kconfig                       |    6 ++++++
 arch/blackfin/Makefile                      |   21 +++++++++++++++++++++
 arch/blackfin/configs/BF533-EZKIT_defconfig |   12 +++++++++++-
 arch/blackfin/configs/BF533-STAMP_defconfig |   26 ++++++++++++++++++++++----
 arch/blackfin/configs/BF537-STAMP_defconfig |   26 ++++++++++++++++++++++----
 arch/blackfin/configs/BF561-EZKIT_defconfig |   12 ++++++++++--
 arch/blackfin/configs/PNAV-10_defconfig     |   13 +++++++++++--
 arch/blackfin/kernel/setup.c                |   18 ++++++++++++++----
 arch/blackfin/kernel/traps.c                |    3 ++-
 include/asm-blackfin/processor.h            |    4 ++++
 10 files changed, 123 insertions(+), 18 deletions(-)
 delete mode 100644 include/asm-blackfin/macros.h
