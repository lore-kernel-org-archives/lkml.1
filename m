Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZHRUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZHRUOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZHRUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:14:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37926 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZHRUOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:14:31 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: Make LSM_MMAP_MIN_ADDR default match its help text.
References: <200908172100.n7HL08SR001061@hera.kernel.org>
	<20090818174736.GA23352@redhat.com>
X-Yow: Has everybody got HALVAH spread all over their ANKLES??...
 Now, it's time to ``HAVE A NAGEELA''!!
Date: Tue, 18 Aug 2009 22:14:29 +0200
In-Reply-To: <20090818174736.GA23352@redhat.com> (Dave Jones's message of
	"Tue, 18 Aug 2009 13:47:37 -0400")
Message-ID: <m2prasq3q2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

>  config LSM_MMAP_MIN_ADDR
>  	int "Low address space for LSM to from user allocation"

This sentence no verb.

Andreas.
---
>From 4ba5116764386ceb1a9da4cb6800defd84f0e3c1 Mon Sep 17 00:00:00 2001
From: Andreas Schwab <schwab@linux-m68k.org>
Date: Tue, 18 Aug 2009 22:08:43 +0200
Subject: [PATCH] Fix prompt for LSM_MMAP_MIN_ADDR.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 security/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 9c60c34..4d1a2e3 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -114,7 +114,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 config LSM_MMAP_MIN_ADDR
-	int "Low address space for LSM to from user allocation"
+	int "Low address space for LSM to protect from user allocation"
 	depends on SECURITY && SECURITY_SELINUX
 	default 65535
 	help
-- 
1.6.4

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
