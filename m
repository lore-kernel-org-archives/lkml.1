Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZDVTG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZDVTG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZDVTF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:05:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:54045 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717AbZDVTF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:05:57 -0400
Message-ID: <49EF6AAE.5000207@suse.de>
Date: Thu, 23 Apr 2009 03:06:22 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Helge Deller <deller@gmx.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/7] parisc: add parameter to read_cr16()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies parameter of au1x_counter1_read() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/parisc/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index d4dd056..d97d07f 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -173,7 +173,7 @@ EXPORT_SYMBOL(profile_pc);

 /* clock source code */

-static cycle_t read_cr16(void)
+static cycle_t read_cr16(struct clocksource *cs)
 {
 	return get_cycles();
 }

-- 
Coly Li
SuSE Labs



