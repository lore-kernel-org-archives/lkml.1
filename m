Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZGZIWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZGZIWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZGZIWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:22:07 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:51192 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZGZIWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:22:03 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jul 2009 04:22:03 EDT
Date: Sun, 26 Jul 2009 09:57:38 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090726075738.GA21333@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 147.251.68.5
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 26 Jul 2009 09:59:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed regression in 2.6.31-rc{3,4}. iwlagn driver does not work for me.
I got:
ifconfig wlan0 up
SIOCSIFFLAGS: Unknown error 132

dmesg shows:
[ 1812.806813] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
1.3.27kds
[ 1812.806820] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 1812.806996] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 1812.807024] iwlagn 0000:03:00.0: setting latency timer to 64
[ 1812.807699] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN
REV=0x4
[ 1812.860879] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a
channels
[ 1812.861012]   alloc irq_desc for 32 on node -1
[ 1812.861017]   alloc kstat_irqs on node -1
[ 1812.861069] iwlagn 0000:03:00.0: irq 32 for MSI/MSI-X
[ 1812.882796] phy0: Selected rate control algorithm 'iwl-agn-rs'

I definitely have rfkill on. I tried to even toggle rfkill, no success. The HW
is Lenovo T61 (thus acer/hp rfkill patches do not work for me).

-- 
Luká¹ Hejtmánek
