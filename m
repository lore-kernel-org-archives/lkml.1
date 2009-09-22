Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZIVRLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZIVRLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZIVRLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:11:22 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56291 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbZIVRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:11:22 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2] Linker script cleanup for blackfin
Date: Tue, 22 Sep 2009 13:10:01 -0400
Message-Id: <1253639402-27975-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linux,

This patch series contains a patch cleaning up the linker script on
the blackfin architecture that's been approved by Mike Frysinger.
Please merge.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (1):
  blackfin: Cleanup linker script using new linker script macros.

 arch/blackfin/kernel/vmlinux.lds.S |   56 ++++--------------------------------
 1 files changed, 6 insertions(+), 50 deletions(-)

