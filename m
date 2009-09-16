Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbZIPQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbZIPQnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbZIPQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:43:34 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40116 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759815AbZIPQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:43:09 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2] Linker script cleanup for avr32
Date: Wed, 16 Sep 2009 12:40:46 -0400
Message-Id: <1253119247-19174-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the patch series I sent in late July
cleaning up the avr32 architecture's linker scripts.  The only change is
that it is rebased on top of Linus's current master.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

Nelson Elhage (1):
  avr32: clean up linker script using standard macros.

 arch/avr32/kernel/vmlinux.lds.S |   64 +++++---------------------------------
 1 files changed, 9 insertions(+), 55 deletions(-)

