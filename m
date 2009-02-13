Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZBMMXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZBMMXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZBMMXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:23:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZBMMXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:23:39 -0500
Date: Fri, 13 Feb 2009 13:23:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 headers: include linux/types.h
Message-ID: <20090213122325.GA30061@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213121858.GB5483@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 56cefcea7c8769ffc04a5609e6ac849e36685468 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 13 Feb 2009 13:23:02 +0100
Subject: [PATCH] x86 headers: include linux/types.h

To properly pick up types relied on by prototypes like 'bool'.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/page.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 467ce69..89ed9d7 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PAGE_H
 #define _ASM_X86_PAGE_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 
 #include <asm/page_types.h>

