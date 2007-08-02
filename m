Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXHBNoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXHBNoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXHBNoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:44:08 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:33133 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbXHBNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:44:07 -0400
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200708021343.l72Dht0K008703@wildsau.enemy.org>
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev numbering]
In-Reply-To: <Pine.LNX.4.64.0708021526310.24572@fbirervta.pbzchgretzou.qr>
To: Jan Engelhardt <jengelh@computergmbh.de>
Date: Thu, 2 Aug 2007 15:43:55 +0200 (MET DST)
CC: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >And now tell me please how can I connect two messages from dmesg:
> >eth0: Tigon3 [partno(BCM95721) rev 4201 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:14:5e:5d:18:26
> >nic10: Link is up at 100 Mbps, full duplex.
> 
> Generally, the "link is xyz" message comes directly after loading the module,
> so it should be eth0 before udev gets a chance to rename it. Or maybe not -
                                                               ^^^^^^^^^^^^

you mean like this:
eth0: MII PHY found at address 1, status 0x7869 advertising 05e1 Link 45e1.
...
eth2: link up, 100Mbps, full-duplex, lpa 0x45E1

with eth0 really being (same MAC) == eth2.

> in which case, well, you're literally fubared, and your distro should put a
> "renamed A to B" into syslog.

I think it would be helpful.

/herp 
