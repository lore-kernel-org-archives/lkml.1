Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYBJHQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYBJHQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbYBJHON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:14:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbYBJHOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:14:07 -0500
Date: Sun, 10 Feb 2008 08:13:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [6/6] kgdb: document parameters
Message-ID: <20080210071352.GF3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

From: Jason Wessel <jason.wessel@windriver.com>

document the kgdboc module/boot parameter.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-kgdb.q/Documentation/kernel-parameters.txt
===================================================================
--- linux-kgdb.q.orig/Documentation/kernel-parameters.txt
+++ linux-kgdb.q/Documentation/kernel-parameters.txt
@@ -930,6 +930,11 @@ and is between 256 and 4096 characters. 
 	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
 			in oops dumps.
 
+	kgdboc=		[HW] kgdb over consoles.
+			Requires a tty driver that supports console polling.
+			(only serial suported for now)
+			Format: <serial_device>[,baud]
+
 	l2cr=		[PPC]
 
 	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
