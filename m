Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbXL3QLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbXL3QLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXL3QLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:11:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44300 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXL3QLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:11:10 -0500
Date: Sun, 30 Dec 2007 17:10:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - RFC] x86: unify arch/x86/kernel/Makefile(s)
Message-ID: <20071230161041.GA27370@elte.hu>
References: <20071230082952.GA12327@uranus.ravnborg.org> <20071230145517.GT16946@elte.hu> <20071230150602.GU16946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230150602.GU16946@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i've added your full patch meanwhile - maybe we can get away with it.

i needed the trivial fix below. You did not test-build it on 32-bit it 
appears :-)

	Ingo

---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/Makefile
===================================================================
--- linux-x86.q.orig/arch/x86/Makefile
+++ linux-x86.q/arch/x86/Makefile
@@ -106,7 +106,7 @@ KBUILD_CFLAGS += $(call cc-option,-mno-s
 # fcore-y is linked before mcore-y files.
 
 # Default subarch .c files
-mcore-y  := arch/x86/mach-default
+mcore-y  := arch/x86/mach-default/
 
 # Voyager subarch support
 mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
