Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZIRUeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZIRUeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZIRUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:34:07 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62426 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZIRUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:34:05 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Chris Zankel <chris@zankel.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2] Linker script cleanup for xtensa
Date: Fri, 18 Sep 2009 16:33:46 -0400
Message-Id: <1253306027-7019-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch I sent on September 6 cleaning
up the xtensa architecture's linker scripts.  It differs from the
previous version only in having been rebased on top of Linus' current
master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (1):
  xtensa: Cleanup linker script using new linker script macros.

 arch/xtensa/kernel/vmlinux.lds.S |   75 +++++++-------------------------------
 1 files changed, 14 insertions(+), 61 deletions(-)

