Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXLFMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXLFMoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXLFMmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:39 -0500
Received: from nic2.axis.se ([193.13.178.10]:35713 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbXLFMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:41:54 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <9f52072058e2e4ff0b013b8b3f281a40021b5ceb.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:26:24 +0100
Subject: [PATCH 08/47] Add SECOND_WORD_SYNC, used in CRISv32 version of sync_serial.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/sync_serial.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-cris/sync_serial.h b/include/asm-cris/sync_serial.h
index f930b6e..d87c24d 100644
--- a/include/asm-cris/sync_serial.h
+++ b/include/asm-cris/sync_serial.h
@@ -67,6 +67,7 @@
 /* Values for SSP_FRAME_SYNC */
 #define NORMAL_SYNC                1
 #define EARLY_SYNC                 2
+#define SECOND_WORD_SYNC     0x40000
 
 #define BIT_SYNC                   4
 #define WORD_SYNC                  8
-- 
1.5.3.6.970.gd25430

