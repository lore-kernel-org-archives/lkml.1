Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYHJJ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYHJJ1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 05:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYHJJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 05:27:45 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:43192 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729AbYHJJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 05:27:45 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig try4
Date: Sun, 10 Aug 2008 19:27:34 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <m2dt9456bt7mbt6s7ic3uhcglu41n09rnc@4ax.com>
References: <m3sktfw1v5.fsf@maximus.localdomain> <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain> <20080809103331.1d475d5c@lxorguk.ukuu.org.uk> <m3zlnm75u1.fsf@maximus.localdomain> <20080809141028.14db9bc7@lxorguk.ukuu.org.uk> <m3skteuhod.fsf@maximus.localdomain> <20080809215918.32f25c4b@lxorguk.ukuu.org.uk> <nifs94lqm5a3qjr3rm2p9mks5tad33cbmi@4ax.com> <cu4t94hi8ei77t57vbmc9am4f2bpsrjtrh@4ax.com> <em9t94trh139dvqdva2tlhu7h3ghsijrbm@4ax.com>
In-Reply-To: <em9t94trh139dvqdva2tlhu7h3ghsijrbm@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Grant Coady <gcoady.lk@gmail.com>

Cleanup ATA Kconfig, this applies after try4 to fix a dependency.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.27-rc2e/drivers/ata/Kconfig~	2008-08-10 18:12:52.495604924 +1000
+++ linux-2.6.27-rc2e/drivers/ata/Kconfig	2008-08-10 19:21:48.941431196 +1000
@@ -344,7 +344,7 @@
 
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
-	depends on PCI && (ATA_SFF_PATA_SUPPORT || ATA_SFF_SATA)
+	depends on PCI && (ATA_SFF_PATA || ATA_SFF_SATA)
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
 	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
