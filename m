Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbYGaKyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbYGaKyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYGaKyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:54:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYGaKyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:54:24 -0400
Date: Thu, 31 Jul 2008 12:53:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 1/4] fastboot: make fastboot a config option
Message-ID: <20080731105337.GK488@elte.hu>
References: <20080720151140.4aa7c682@infradead.org> <20080720151234.4535ee73@infradead.org> <20080730082335.4da1296f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730082335.4da1296f.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > +	  This includes doing some of the device initialization asynchronous
> 
> 	                                                        asynchronously
> 

fixed in tip/fastboot via the patch below - thanks Randy.

	Ingo

------------->
>From 1a23ed42e1baf0481cc70c2f71d97b0bf0f1be70 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 31 Jul 2008 12:52:29 +0200
Subject: [PATCH] fastboot: fix typo in init/Kconfig text

noticed by Randy Dunlap.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 4f73780..6b4de4d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -530,7 +530,7 @@ config FASTBOOT
 	  The fastboot option will cause the kernel to try to optimize
 	  for faster boot. 
 
-	  This includes doing some of the device initialization asynchronous
+	  This includes doing some of the device initialization asynchronously
 	  as well as opportunistically trying to mount the root fs early.
 
 	  If unsure, say N.
