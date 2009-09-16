Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZIPQkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZIPQkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759763AbZIPQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:40:28 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38609 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759749AbZIPQkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:40:25 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 0/2] Linker script cleanup patches for arm
Date: Wed, 16 Sep 2009 12:39:53 -0400
Message-Id: <1253119195-19056-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent in late July
cleaning up the arm architecture's linker scripts.  The only change is
that it is rebased on top of Linus's current master.

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
 arch/arm/kernel/vmlinux.lds.S |   84 ++++++++++++-----------------------------
 3 files changed, 26 insertions(+), 62 deletions(-)

