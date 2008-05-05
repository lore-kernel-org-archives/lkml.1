Return-Path: <linux-kernel-owner+w=401wt.eu-S1762904AbYEEVrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904AbYEEVrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761913AbYEEVra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:47:30 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:56622 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167AbYEEVr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:47:29 -0400
Date: Tue, 6 May 2008 07:47:27 +1000
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       guichaz@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, efault@gmx.de, dhaval@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] sched_clock_cpu()
Message-ID: <20080505214727.GU20457@bakeyournoodle.com>
References: <1209832169.6929.42.camel@lappy> <20080503170130.GB21967@elte.hu> <20080503.212607.157994166.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080503.212607.157994166.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 09:26:07PM -0700, David Miller wrote:

> It would be nice if a powerpc person could test the trivial
> powerpc Kconfig patch.

FWIW I tested the following trivial patch for powerpc.  While testing
this I discovered a i(related) ppc32 regressesion that I'm trying to
bisect/debug.


Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
Obviously on top of the merged patch + Dave's sparc patch

 arch/powerpc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 3934e26..0642dff 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -110,6 +110,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select HAVE_STABLE_CLOCK
 
 config EARLY_PRINTK
 	bool

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

