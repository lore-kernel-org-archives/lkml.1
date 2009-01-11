Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZAKTcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZAKTcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZAKTcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:32:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZAKTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:32:44 -0500
Message-Id: <cover.1231695451.git.kkeil@suse.de>
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 15:37:31 +0100
Subject: [PATCH 0/7] Small fixes for mISDN
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional fixes to mISDN.

Please pull from:
git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6 for_2.6.29

Ilpo Järvinen (3):
  indentation & braces disagree - add braces
  misdn: one handmade ARRAY_SIZE converted
  misdn: indentation and braces disagree - add braces

Julia Lawall (1):
  drivers/isdn/hardware/mISDN: move a dereference below a NULL test

Karsten Keil (2):
  Make parameter debug writable
  Fix small typo

Martin Bachem (1):
  BUGFIX: used NULL pointer at ioctl(sk,IMGETDEVINFO,&devinfo) when
    devinfo.id not registered

 drivers/isdn/hardware/mISDN/hfcmulti.c |    3 ++-
 drivers/isdn/hardware/mISDN/hfcpci.c   |    2 +-
 drivers/isdn/mISDN/dsp_cmx.c           |    5 +++--
 drivers/isdn/mISDN/dsp_pipeline.c      |    4 ++--
 include/linux/mISDNif.h                |    5 ++++-
 5 files changed, 12 insertions(+), 7 deletions(-)

