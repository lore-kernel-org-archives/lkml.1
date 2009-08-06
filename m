Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZHFLHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZHFLHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZHFLHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:07:00 -0400
Received: from d1.icnet.pl ([212.160.220.21]:41978 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbZHFLG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:06:59 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 0/2] Give the N_AMSDELTA line discipline more generic name
Date: Thu, 6 Aug 2009 13:06:26 +0200
User-Agent: KMail/1.9.10
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       e3-hacking@earth.li,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061306.27639.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches renames the N_AMSDELTA line discipline, used by the 
Amstrad Delta ASoC machine driver and the CX20442 ASoC codec driver for 
controlling the CX20442 voice codec over the CX81801 voice modem, giving it a 
more generic name: N_V253. The name has been chosen after the voice modem 
standard codename V.253.

I think that even if the code of the line discipline is currently implemented 
inside those two specific drivers, the idea, if not the code, could be reused 
with other similar hardware configurations, if necessary.

As the line discipline is conceived to be registered from a machine driver, 
there should be no conflicts, even if used by several different drivers that 
happen to be be built-in side-by-side.

[PATCH 1/2] TTY: Rename N_AMSDELTA line discipline to N_V253
[PATCH 2/2] ASoC: AMS_DELTA: Use updated line discipline name

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
