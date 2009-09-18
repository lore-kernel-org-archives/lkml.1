Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZIRTwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZIRTwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZIRTww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:52:52 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41007 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbZIRTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:52:51 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 0/3] Linker script cleanup patches for sparc and frv
Date: Fri, 18 Sep 2009 15:52:06 -0400
Message-Id: <1253303529-6342-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch series contains patches cleaning up the linker scripts on
the frv and sparc architectures that have been acked by the relevant
maintainers.  Please merge.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

Geoffrey Thomas (1):
  sparc: Clean up linker script using new linker script macros.

Nelson Elhage (2):
  frv: remove unused .altinstructions code
  frv: clean up linker script using new linker script macros.

 arch/frv/kernel/vmlinux.lds.S   |   66 ++++------------------------------
 arch/sparc/kernel/vmlinux.lds.S |   75 ++++-----------------------------------
 2 files changed, 14 insertions(+), 127 deletions(-)

