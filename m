Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbXGBG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbXGBG0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 02:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXGBG0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 02:26:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:37909 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbXGBG0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 02:26:18 -0400
X-IronPort-AV: i="4.16,485,1175486400"; 
   d="scan'208"; a="44094436:sNHT23253440"
Subject: [GIT PULL] Blackfin arch fixes
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 02 Jul 2007 14:31:24 +0800
Message-Id: <1183357884.32471.9.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 02 Jul 2007 06:26:17.0041 (UTC) FILETIME=[E5764C10:01C7BC71]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from "master" branch of:

  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/ master

Jie Zhang (1):
      Blackfin arch: Add proper -mcpu option according to the cpu and silicon revision configuration

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
