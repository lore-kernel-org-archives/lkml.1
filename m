Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZDVTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZDVTFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDVTEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:04:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:54008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZDVTEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:04:48 -0400
Message-ID: <49EF6A69.7070004@suse.de>
Date: Thu, 23 Apr 2009 03:05:13 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <rmk@dyn-67.arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/7] mach-sa1100: add parameter to sa1100_read_oscr()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies parameter of sa1100_read_oscr() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Russell King <rmk@dyn-67.arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/mach-sa1100/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 711c029..f6f1e5b 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -77,7 +77,7 @@ static struct clock_event_device ckevt_sa1100_osmr0 = {
 	.set_mode	= sa1100_osmr0_set_mode,
 };

-static cycle_t sa1100_read_oscr(void)
+static cycle_t sa1100_read_oscr(struct clocksource *cs)
 {
 	return OSCR;
 }

-- 
Coly Li
SuSE Labs



