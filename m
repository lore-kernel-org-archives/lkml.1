Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXJQTTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXJQTTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbXJQTT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:19:29 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:45716 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbXJQTT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:19:27 -0400
Date: Wed, 17 Oct 2007 21:19:23 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>
Subject: mmc_spi stopped working
Message-ID: <20071017211923.31fde15e@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I just tried out mmc_spi on Linux HEAD and it no longer works. :/

It seems to be caused by changes in the SPI core on how to handled bus
sharing. All I'm getting in dmesg is this:

[17179577.832000] mmc_spi spi1.0: can't share SPI bus
[17179577.836000] mmc_spi: probe of spi1.0 failed with error -31

Ideas? This platform worked fine with 2.6.23-rc*

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
