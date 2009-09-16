Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZIPUlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZIPUlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbZIPUlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:41:02 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45718 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760039AbZIPUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:41:00 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 0/2] Linker script cleanup patches for arm
Date: Wed, 16 Sep 2009 16:40:04 -0400
Message-Id: <1253133606-24918-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent in late July
cleaning up the arm architecture's linker scripts.  Version 2 was
rebased on top of Linus's current master; version 3 contains a fix
for a problem with CONFIG_XIP_KERNEL noted by Russell King.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Nelson Elhage (1):
  arm: Clean up linker script using new linker script macros.

Tim Abbott (1):
  arm: convert to use __HEAD and HEAD_TEXT macros.

 arch/arm/kernel/head-nommu.S  |    2 +-
 arch/arm/kernel/head.S        |    2 +-
 arch/arm/kernel/vmlinux.lds.S |   86 ++++++++++++----------------------------
 3 files changed, 28 insertions(+), 62 deletions(-)

