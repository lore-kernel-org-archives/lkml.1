Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZIVPS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZIVPS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZIVPS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:18:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57765 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbZIVPS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:18:56 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2] Linker script cleanup for powerpc
Date: Tue, 22 Sep 2009 11:18:08 -0400
Message-Id: <1253632689-24173-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch I sent on September 6 cleaning
up the powerpc architecture's linker scripts.  The only change is that
it is rebased on top of Linus's current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (1):
  powerpc: Cleanup linker script using new linker script macros.

 arch/powerpc/kernel/vmlinux.lds.S |   69 ++++++++-----------------------------
 1 files changed, 15 insertions(+), 54 deletions(-)

