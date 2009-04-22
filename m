Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZDVTF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZDVTF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZDVTFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:05:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbZDVTFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:05:41 -0400
Message-ID: <49EF6A9E.6080605@suse.de>
Date: Thu, 23 Apr 2009 03:06:06 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Daney <ddaney@caviumnetworks.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/7] mips cavium-octeon: add parameter to octeon_cvmcount_read()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies parameter of octeon_cvmcount_read() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/mips/cavium-octeon/csrc-octeon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/csrc-octeon.c
b/arch/mips/cavium-octeon/csrc-octeon.c
index 70fd92c..96110f2 100644
--- a/arch/mips/cavium-octeon/csrc-octeon.c
+++ b/arch/mips/cavium-octeon/csrc-octeon.c
@@ -38,7 +38,7 @@ void octeon_init_cvmcount(void)
 	local_irq_restore(flags);
 }

-static cycle_t octeon_cvmcount_read(void)
+static cycle_t octeon_cvmcount_read(struct clocksource *cs)
 {
 	return read_c0_cvmcount();
 }

-- 
Coly Li
SuSE Labs



