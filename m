Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbZIPQrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbZIPQrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbZIPQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:47:00 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42154 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751AbZIPQqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:46:52 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2] Linker script cleanup for sparc
Date: Wed, 16 Sep 2009 12:46:31 -0400
Message-Id: <1253119592-19598-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent in late July
cleaning up the sparc architecture's linker scripts.  The only change is
that it is rebased on top of Linus's current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Geoffrey Thomas (1):
  sparc: Clean up linker script using new linker script macros.

 arch/sparc/kernel/vmlinux.lds.S |   75 ++++-----------------------------------
 1 files changed, 7 insertions(+), 68 deletions(-)

