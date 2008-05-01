Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYEACHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYEACHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYEACHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:07:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYEACHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:07:20 -0400
Date: Thu, 1 May 2008 04:06:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080501020645.GD27574@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501011703.GA27574@elte.hu> <20080501013739.GQ29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501013739.GQ29330@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> The bug is in arch/x86/Kconfig .
> 
> Caused by commit 4cf31841762954ad2868156ccba94d798a16630f (x86: 
> mach-rdc321x Kconfig fix).

ah, indeed - Florian Cc:-ed. Preliminary quick hack below.

	Ingo

--------------->
Subject: rdc: leds hack
From: Ingo Molnar <mingo@elte.hu>
Date: Thu May 01 03:46:22 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -322,6 +322,7 @@ config X86_RDC321X
 	select GENERIC_GPIO
 	select LEDS_CLASS
 	select LEDS_GPIO
+	select NEW_LEDS
 	help
 	  This option is needed for RDC R-321x system-on-chip, also known
 	  as R-8610-(G).
