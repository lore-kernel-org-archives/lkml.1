Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYG2ILi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYG2ILi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbYG2ILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:11:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbYG2ILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:11:08 -0400
Date: Tue, 29 Jul 2008 10:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 00/11] x86: AMD microcode patch loading support v2
Message-ID: <20080729081051.GC14838@elte.hu>
References: <20080728164411.490752571@amd.com> <20080728180141.GB2937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728180141.GB2937@elte.hu>
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


>From 5d7b605245b1aa1a9cd6549b1f57d69273eb0c37 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Jul 2008 10:07:36 +0200
Subject: [PATCH] x86, microcode: fix module license string

fix:

 FATAL: modpost: GPL-incompatible module microcode_amd.ko uses GPL-only symbol 'set_cpus_allowed_ptr'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index db199e3..fd9e68e 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -40,7 +40,7 @@
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
 MODULE_AUTHOR("Peter Oruba <peter.oruba@amd.com>");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 
 #define UCODE_MAGIC                0x00414d44
 #define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
