Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZDVTFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZDVTFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZDVTFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:05:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:54026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZDVTFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:05:23 -0400
Message-ID: <49EF6A8C.2050300@suse.de>
Date: Thu, 23 Apr 2009 03:05:48 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/7] mips alchemy: add parameter to au1x_counter1_read()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies parameter of au1x_counter1_read() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/mips/alchemy/common/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
index f58d4ff..33fbae7 100644
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -44,7 +44,7 @@

 extern int allow_au1k_wait; /* default off for CP0 Counter */

-static cycle_t au1x_counter1_read(void)
+static cycle_t au1x_counter1_read(struct clocksource *cs)
 {
 	return au_readl(SYS_RTCREAD);
 }
-- 
Coly Li
SuSE Labs



