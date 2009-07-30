Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZG3JN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZG3JN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZG3JN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:13:56 -0400
Received: from d1.icnet.pl ([212.160.220.21]:47046 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZG3JNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:13:55 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC] [PATCH 3/3 v2] ASoC: add support for Amstrad E3 (Delta) machine
Date: Thu, 30 Jul 2009 11:12:52 +0200
User-Agent: KMail/1.9.10
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200907291318.54897.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200907291318.54897.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907301112.53525.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wednesday 29 July 2009 13:18:53 Janusz Krzysztofik napisał(a):
> This patch adds machine support for Amstrad E3 (Delta) videophone to ASoC.
>
> Created and tested against linux-2.6.31-rc3.

I am aware that I have forgot to correct one checkpatch indicated issue. Sorry
for this.  If there are no other changes to the locking bits suggested, the
issue will be corrected this way:

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

--- linux-2.6.31-rc3/sound/soc/omap/ams-delta.c.orig    2009-07-30 11:01:37.000000000 +0200
+++ linux-2.6.31-rc3/sound/soc/omap/ams-delta.c 2009-07-30 00:52:34.000000000 +0200
@@ -251,7 +251,7 @@ static struct snd_soc_jack_pin ams_delta
 static struct timer_list cx81801_timer;
 static bool cx81801_cmd_pending;
 static bool ams_delta_muted;
-static spinlock_t ams_delta_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(ams_delta_lock);

 static void cx81801_timeout(unsigned long data)
 {
