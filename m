Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYCUCYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYCUCYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 22:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYCUCYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 22:24:23 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:61910 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbYCUCYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 22:24:05 -0400
Date: Thu, 20 Mar 2008 22:23:50 -0400
From: "Peter F. Patel-Schneider" <pfps@verizon.net>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia,
 disabling IRQ #9 and Re: libata and legacy ide pcmcia failure
In-reply-to: <20080321011205.4c7b4a61@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Message-id: <47E31C36.20002@verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <47067DB9.80200@roarinelk.homelinux.net>
 <47E300B2.7000104@verizon.net> <20080321011205.4c7b4a61@core>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

 >> Mar 20 19:51:45 idefix kernel: ata12: PATA max PIO0 cmd 0xa100 ctl 
0xa10e irq 3
 >> Mar 20 19:52:15 idefix kernel: ata12.00: qc timeout (cmd 0x91)
 >> Mar 20 19:52:15 idefix kernel: ata12.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
 >
 > Thinkpad T61p .. I've seen a few of these.

(Actually a T60p. I guess I'm getting envious.)

 > Firstly try the card and adapter in a different PC and let me know if
 > that works. So far they do. If that is the case get the latest firmware
 > updates (BIOS etc) for your thinkpad and see if the problem goes away.
 > They (or our ACPI code I guess it may be) have some serious IRQ routing
 > problems on this box.
 >
 > Alan

The card and adapter (right now a Kodak picture card adapter and an old
64MB Kodak CF card, but, as I said, the behaviour is the same with
different adapters and different CF cards) work correctly in my Wife's
Evo running Windows.   The adapter and card work, sometimes, when they
are in the machine at boot (like on my last boot - I have a 
/var/log/messages
with this behaviour, but it isn't very illuminating).   I have had 
several T60p's,
they all act the same.  (The on-site service center swaps machines for us
when we have problems.)

I just updated to the current BIOS (2.21) and ECP (1.07).  Not working.
(Just for the record the kernel is 2.6.24.3-34.fc8 #1 SMP.)

Here are the /var/log/messages after inserting the card and adapter.

Mar 20 22:13:19 idefix kernel: pccard: PCMCIA card inserted into slot 0
Mar 20 22:13:19 idefix kernel: cs: memory probe 0xe4300000-0xe7ffffff: 
excluding 0xe4300000-0xe46cffff 0xe4e70000-0xe523ffff 
0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
Mar 20 22:13:19 idefix kernel: pcmcia: registering new device pcmcia0.0
Mar 20 22:13:19 idefix kernel: scsi6 : pata_pcmcia
Mar 20 22:13:19 idefix kernel: ata7: PATA max PIO0 cmd 0xa100 ctl 0xa10e 
irq 3
Mar 20 22:13:49 idefix kernel: ata7.00: qc timeout (cmd 0x91)
Mar 20 22:13:49 idefix kernel: ata7.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
Mar 20 22:13:49 idefix kernel: ata7: failed to recover some devices, 
retrying in 5 secs
Mar 20 22:14:24 idefix kernel: ata7.00: qc timeout (cmd 0x91)
Mar 20 22:14:24 idefix kernel: ata7.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
Mar 20 22:14:24 idefix kernel: ata7: failed to recover some devices, 
retrying in 5 secs
Mar 20 22:14:59 idefix kernel: ata7.00: qc timeout (cmd 0x91)
Mar 20 22:14:59 idefix kernel: ata7.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
Mar 20 22:14:59 idefix kernel: ata7: failed to recover some devices, 
retrying in 5 secs

peter


