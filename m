Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbXEOBAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbXEOBAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 21:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbXEOBA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 21:00:27 -0400
Received: from [81.27.192.123] ([81.27.192.123]:5170 "EHLO av1.karneval.cz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbXEOBA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 21:00:26 -0400
X-Greylist: delayed 1726 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 21:00:25 EDT
From: Pavel Pisa <ppisa@pikron.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC] Orphaning MMC host drivers
Date: Tue, 15 May 2007 02:30:36 +0200
User-Agent: KMail/1.9.4
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       "Juha =?iso-8859-2?q?Yrj=F6l=E4?=" <juha.yrjola@solidboot.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       "Briglia >> \"Anderson F. Briglia\"" <anderson.briglia@indt.org.br>,
       Kyungmin Park <kmpark@infradead.org>, "Khasim, Syed" <x0khasim@ti.com>,
       Sascha Hauer <s.hauer@pengutronix.de>
References: <4648BAC9.5020405@drzeus.cx>
In-Reply-To: <4648BAC9.5020405@drzeus.cx>
Organization: PiKRON Ltd.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705150230.38617.ppisa@pikron.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 21:38, Pierre Ossman wrote:
> @@ -2382,6 +2391,9 @@ M:        stelian@popies.net
>  W:     http://popies.net/meye/
>  S:     Maintained
>  
> +MOTOROLA I.MX MMCI DRIVER
> +S:     Orphan
> +
>  MOUSE AND MISC DEVICES [GENERAL]
>  P:     Alessandro Rubini
>  M:     rubini@ipvvis.unipv.it
> @@ -2902,6 +2914,9 @@ M:        nico@cam.org

Hello Pierre,

as I have already stated, I would take responsibility
for I.MX SDHC driver. It is not perfect, but I am trying
to keep and fix it and I would be happy to receive
feedback or help from others.

The actual state is such, that read works for both SD/MMC,
but write is failing. The write path is timing sensitive
and some other kernel changes above 2.6.18 exposes these
problems. I have some ideas, how to dig for this problem
in mind, but I did not find time to try them yet.

I have already proposed MAINTAINERS change, but you
did not liked to point L: field to "sdhci-devel" list.
I propose ALKML mailing list this time as you suggested.

Do you include change or should I send my own patch
for review? Would you suggest change in driver name
to MOTOROLA I.MX MMCI DRIVER ?

Best wishes

            Pavel

My original proposal with L: changed to ALKML

Index: linux-2.6.21/MAINTAINERS
===================================================================
--- linux-2.6.21.orig/MAINTAINERS
+++ linux-2.6.21/MAINTAINERS
@@ -1717,6 +1717,13 @@ M:       lethal@chaoticdreams.org
 L:     linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:     Maintained

+IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
+P:     Pavel Pisa
+M:     ppisa@pikron.com
+L:     linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+W:     http://mmc.drzeus.cx/wiki/Controllers/Freescale/SDHC
+S:     Maintained
+
 INFINIBAND SUBSYSTEM
 P:     Roland Dreier
 M:     rolandd@cisco.com


