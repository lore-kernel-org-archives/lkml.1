Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYGVPEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYGVPEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYGVPEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:04:40 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:39859 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYGVPEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:04:39 -0400
Date: Tue, 22 Jul 2008 17:04:38 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: Regression: myri10ge driver in 2.6.26
Message-ID: <20080722150438.GK4359@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 22 Jul 2008 17:04:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the myri10ge driver in 2.6.26 vanila kernel does not work.

Loading the driver produces only:
[   86.641632] myri10ge: Version 1.3.99-1.347
[   86.641632] PCI: Setting latency timer of device 0000:07:00.0 to 64

and nothing more.

The driver from Myricom web page version 1.4.2 works fine under the same
kernel:
[  664.668857] myri10ge: Version 1.4.2
[  664.668857] PCI: Setting latency timer of device 0000:07:00.0 to 64
[  664.675996] firmware: requesting myri10ge_eth_z8e.dat
[  664.704897] myri10ge 0000:07:00.0: Unable to load myri10ge_eth_z8e.dat
firmware image via hotplug
[  664.704897] myri10ge 0000:07:00.0: hotplug firmware loading failed
[  664.704897] myri10ge 0000:07:00.0: Successfully adopted running firmware
[  664.704897] myri10ge 0000:07:00.0: Using firmware currently running on NIC.
For optimal
[  664.704897] myri10ge 0000:07:00.0: performance consider loading optimized
firmware
[  664.704897] myri10ge 0000:07:00.0: via hotplug
[  664.754309] firmware: requesting adopted
[  664.754896] myri10ge 0000:07:00.0: Unable to load adopted firmware image
via hotplug
[  664.754896] myri10ge 0000:07:00.0: hotplug firmware loading failed
[  664.754896] myri10ge 0000:07:00.0: Successfully adopted running firmware
[  664.828230] myri10ge 0000:07:00.0: MSI IRQ 499, tx bndry 2048, fw adopted,
WC Enabled


-- 
Luká¹ Hejtmánek
