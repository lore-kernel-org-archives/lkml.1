Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXKGFp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXKGFp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbXKGFpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:45:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38974 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXKGFpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:45:19 -0500
Date: Wed, 7 Nov 2007 06:46:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071107054657.GA13450@uranus.ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071106230451.GA10886@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106230451.GA10886@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 12:04:51AM +0100, Sam Ravnborg wrote:
> This serie of patches unify the X86 Kconfig files.
> Next step is to enable use of "make ARCH=x86" and kill
> "make ARCH=i386/x86_64".
> But that will wait till tomorrow.
> 
> The allmodconfig kernel is still building here.
> Testing / reviews appreciated.

Small fix to let allmodconfig build on x86_64.
I need to doublecheck why this bug sneaked in but that will be tonight.

	Sam

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0acb92f..dab26a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -79,7 +79,7 @@ config ARCH_MAY_HAVE_PC_FDC
 
 config DMI
 	bool
-	default X86_32
+	default y
 
 config RWSEM_GENERIC_SPINLOCK
 	def_bool !X86_XADD
