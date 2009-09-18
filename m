Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZIRUgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZIRUgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbZIRUgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:36:04 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63318 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932114AbZIRUgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:36:00 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2] Linker script cleanup for um
Date: Fri, 18 Sep 2009 16:35:31 -0400
Message-Id: <1253306132-7117-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch I sent on September 6 cleaning
up the um architecture's linker scripts.  It differs from the previous
version only in having been rebased on top of Linus' current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (1):
  um: Clean up linker script using standard macros.

 arch/um/include/asm/common.lds.S |   29 ++++++-----------------------
 arch/um/kernel/dyn.lds.S         |    9 ++-------
 arch/um/kernel/uml.lds.S         |   26 ++++++--------------------
 3 files changed, 14 insertions(+), 50 deletions(-)

