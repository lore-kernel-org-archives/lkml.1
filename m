Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYCUA0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYCUA0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYCUA0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:26:39 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:47404 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYCUA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:26:38 -0400
Date: Thu, 20 Mar 2008 20:26:26 -0400
From: "Peter F. Patel-Schneider" <pfps@verizon.net>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia,
 disabling IRQ #9 and Re: libata and legacy ide pcmcia failure
In-reply-to: <47067DB9.80200@roarinelk.homelinux.net>
To: linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@verizon.net>
Cc: "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Message-id: <47E300B2.7000104@verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <47067DB9.80200@roarinelk.homelinux.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

There have been several threads related to continuing problems with CF 
flash memory card in PCMCIA adapters not being recognized and leading to 
traces like:
Mar 20 19:51:44 idefix kernel: pccard: PCMCIA card inserted into slot 0
Mar 20 19:51:44 idefix kernel: pcmcia: registering new device pcmcia0.0
Mar 20 19:51:45 idefix kernel: scsi17 : pata_pcmcia
Mar 20 19:51:45 idefix kernel: ata12: PATA max PIO0 cmd 0xa100 ctl 
0xa10e irq 3
Mar 20 19:52:15 idefix kernel: ata12.00: qc timeout (cmd 0x91)
Mar 20 19:52:15 idefix kernel: ata12.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
Mar 20 19:52:15 idefix kernel: ata12: failed to recover some devices, 
retrying in 5 secs
Mar 20 19:52:50 idefix kernel: ata12.00: qc timeout (cmd 0x91)
Mar 20 19:52:50 idefix kernel: ata12.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
Mar 20 19:52:50 idefix kernel: ata12: failed to recover some devices, 
retrying in 5 secs

I, too, am experiencing this problem (and have been for about a year).  
Currently I'm running
2.6.24.3-34.fc8 #1 SMP on a Thinkpad T61p, but the problem has surfaced 
in all recent (to me) kernels.  I've tried with two different PCMCIA CF 
adapters and quite a few CF cards - all exhibit the same broken behaviour.

I can't find a resolution.  If there isn't one I'm willing to donate one 
of my adapters and a CF card so that anyone with a PCMCIA slot can test 
out the situation.

By the way, the problem occurs for me on insertion into a running 
system.  If I boot with the PCMCIA adapter and CF card in, I either get 
a freeze during udev startup (until I remove the card and then the 
system works fine) or I get the card mounted as a disk, and everything 
works fine.  I'm willing to provide more information about these two 
situations if anyone is interested.  The same CF card works fine when 
put into a USB multi-card reader as well.

Peter F. Patel-Schneider
Bell Labs Research

PS:  Please cc me directly if possible on replies, thanks.
