Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbXLFMqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbXLFMqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbXLFMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:46 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53712 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXLFMmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:23 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <c8f99603f7d1751010c173befaeaf2a30f82444b.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 10:12:31 +0100
Subject: [PATCH 14/47] Add headers for CRISv32 chips EtraxFS and Artpec-3.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/Kbuild |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-cris/Kbuild b/include/asm-cris/Kbuild
index 14498d5..7ce0692 100644
--- a/include/asm-cris/Kbuild
+++ b/include/asm-cris/Kbuild
@@ -1,5 +1,8 @@
 include include/asm-generic/Kbuild.asm
 
+header-$(CONFIG_ETRAX_ARCH_V10) += arch-v10/
+header-$(CONFIG_ETRAX_ARCH_V32) += arch-v32/
+
 header-y += arch-v10/ arch-v32/
 
 unifdef-y += rs485.h
-- 
1.5.3.6.970.gd25430

