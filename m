Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZGVDXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZGVDXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZGVDXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:23:37 -0400
Received: from d1.icnet.pl ([212.160.220.21]:39029 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZGVDXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:23:36 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tony Lindgren <tony@atomide.com>
Subject: [RFC] [PATCH 0/3] Add support for Amstrad E3 (Delta) audio to ASoC
Date: Wed, 22 Jul 2009 05:22:13 +0200
User-Agent: KMail/1.9.10
Cc: Arun KS <arunks@mistralsolutions.com>, Jarkko Nikula <jhnikula@gmail.com>,
       Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907220522.15134.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support for audio device found on Amstrad E3 
(Delta) videophone to ASoC.

1/3:	ASoC: Add support for Conexant CX20442-11 voice modem codec
2/3:	TTY: Add definition of a new line discipline required by Amstrad E3
	(Delta) ASoC driver
3/3:	ASoC: add support for Amstrad E3 (Delta) machine
4/3:	OMAP1: Readd basic support for DSP initialization

Created and tested against linux-2.5.31-rc3.
Applies and works with linux-omap-2.6 commit 
7c5cb7862d32cb344be7831d466535d5255e35ac as well

Patch 4/3 is a temporary solution that should help interested parties in 
testing the driver or even making use of it before an official DSP support 
gets back to the omap or mainline tree.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
