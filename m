Return-Path: <linux-kernel-owner+w=401wt.eu-S2992524AbXCGTtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524AbXCGTtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992527AbXCGTtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:49:10 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:57871 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992524AbXCGTtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:49:07 -0500
From: Mws <mws@twisted-brains.org>
To: linux-kernel@vger.kernel.org
Subject: irq nobody cared issue on 2.6.2x
Date: Wed, 7 Mar 2007 20:48:49 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703072048.49637.mws@twisted-brains.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i just moved my win tv dvb-s card (PCI) from my old to my actual pc.

its an ASUS M2N32 WS Professional AMD64 X2 Board equiped with
the nvidia nForce 590 SLI MCP chipset.

in the past, i had to use the noapic kernel cmdline param to get linux
booting and working properly.

iirc versions >=2.6.18 of the kernel fixed all of my previous problems,
thus i am not using noapic since then.

if you would be so kind to provide me some infos,

how i would be able to track the problem down _and_ maybe how to fix it.

please find two snippets of dmesg after booting 2.6.21-rc3-git 
(2.6.20-1 has got the same results) 

best regards
marcel





snip of logs

_normal_ boot on 2.6.21-rc3 git

Freeing unused kernel memory: 264k freed
saa7146: register extension 'dvb'.
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
saa7146: found saa7146 @ mem ffffc20000070000 (revision 1, irq 16) (0x13c2,0x0003).
DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.X).
adapter has MAC addr = 00:d0:5c:1f:6d:3f
irq 16: nobody cared (try booting with the "irqpoll" option)

Call Trace:
 <IRQ>  [<ffffffff801473d7>]
 [<ffffffff801475e2>]
 [<ffffffff80147e97>]
 [<ffffffff8010a62c>]
 [<ffffffff8010c0e2>]
 [<ffffffff8010882e>]
 [<ffffffff80109a41>]
 <EOI>  [<ffffffff80108857>]
 [<ffffffff801088bc>]

handlers:
[<ffffffff88015619>]
Disabling IRQ #16
dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 80f12623
dvb-ttpci: firmware @ card 0 supports CI link layer interface

boot on 2.6.21-rc3 git irqpoll option
Freeing unused kernel memory: 260k freed
saa7146: register extension 'dvb'.
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
saa7146: found saa7146 @ mem ffffc20000026000 (revision 1, irq 16) (0x13c2,0x0003).
DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.X).
adapter has MAC addr = 00:d0:5c:1f:6d:3f
dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 80f12623
dvb-ttpci: firmware @ card 0 supports CI link layer interface
dvb-ttpci: adac type set to 0 @ card 0
saa7146_vv: saa7146 (0): registered device video0 [v4l2]
saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
DVB: registering frontend 0 (ST STV0299 DVB-S)...
input: DVB on-card IR receiver as /class/input/input3
dvb-ttpci: found av7110-0.
XFS mounting filesystem sda1

later on....
Adding 1004052k swap on /dev/hda2.  Priority:-1 extents:1 across:1004052k
irq 16: nobody cared (try booting with the "irqpoll" option)

Call Trace:
 <IRQ>  [<ffffffff80147763>]
 [<ffffffff80147982>]
 [<ffffffff801481a6>]
 [<ffffffff8010a7cc>]
 [<ffffffff8010c291>]
 [<ffffffff80108a3e>]
 [<ffffffff80109c51>]
 <EOI>
handlers:
[<ffffffff88015612>]
Disabling IRQ #16
