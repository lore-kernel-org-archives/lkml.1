Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968516Ab0B0PSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:18:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968136Ab0B0PSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:18:37 -0500
Date: Sat, 27 Feb 2010 16:18:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/gpu change for v2.6.34
Message-ID: <20100227151831.GA11385@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-gpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-gpu-for-linus

 Thanks,

	Ingo

------------------>
Dave Airlie (1):
      x86-64: Allow fbdev primary video code


 arch/x86/Makefile         |    2 --
 arch/x86/include/asm/fb.h |    4 ----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 78b32be..0a43dc5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -135,9 +135,7 @@ drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
 # suspend and hibernation support
 drivers-$(CONFIG_PM) += arch/x86/power/
 
-ifeq ($(CONFIG_X86_32),y)
 drivers-$(CONFIG_FB) += arch/x86/video/
-endif
 
 ####
 # boot loader support. Several targets are kept for legacy purposes
diff --git a/arch/x86/include/asm/fb.h b/arch/x86/include/asm/fb.h
index 5301846..2519d06 100644
--- a/arch/x86/include/asm/fb.h
+++ b/arch/x86/include/asm/fb.h
@@ -12,10 +12,6 @@ static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
 }
 
-#ifdef CONFIG_X86_32
 extern int fb_is_primary_device(struct fb_info *info);
-#else
-static inline int fb_is_primary_device(struct fb_info *info) { return 0; }
-#endif
 
 #endif /* _ASM_X86_FB_H */
