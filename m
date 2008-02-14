Return-Path: <linux-kernel-owner+w=401wt.eu-S1764977AbYBNXfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764977AbYBNXfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759316AbYBNXfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:35:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:30405 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653AbYBNXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FVskIr2/vc6qR1/vFF39zIrl8bysYCkQGKgm46XYPDR5bZP8fMNLEiuOWCyRdhmqI38C8gl0QlT3sf5iNW+9kZ7a9zTCHUeeNJ2uQWQT5cArp+TKCLzBkGP5x+/3KlS05OJOVe67koNSi1ajYpglcvqI3EtL4b6nE151Ia0s07E=
Message-ID: <47B4D02E.9030101@gmail.com>
Date: Fri, 15 Feb 2008 08:35:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
References: <20080214184700.0bd3837d@highlander.home.lan>
In-Reply-To: <20080214184700.0bd3837d@highlander.home.lan>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malte Schröder wrote:
> Hello,
> on one of my machines neither 2.6.24 nor 2.6.24.1 work.
> The system is 64bit on Athlon X2 and ATI-Chipset (SB600).
> 
> Extract from the kernel messages during boot:
> 
> [   66.943103] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
> [   66.950374] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_PMP
> [   67.956470] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> [   67.964996] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part
> [   67.972820] scsi0 : ahci
> [   67.975699] scsi1 : ahci
> [   67.978445] scsi2 : ahci
> [   67.981178] scsi3 : ahci
> [   67.983949] ata1: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffd00 irq 509
> [   67.991825] ata2: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffd80 irq 509
> [   67.999729] ata3: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffe00 irq 509
> [   68.007619] ata4: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffe80 irq 509
> [   68.470669] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   98.431945] ata1.00: qc timeout (cmd 0xec)
> [   98.454907] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [   98.461296] ata1: failed to recover some devices, retrying in 5 secs
> [  103.916773] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  133.878045] ata1.00: qc timeout (cmd 0xec)
> [  133.882371] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  133.888797] ata1: failed to recover some devices, retrying in 5 secs
> [  139.343901] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  169.305174] ata1.00: qc timeout (cmd 0xec)
> [  169.309534] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  169.315926] ata1: failed to recover some devices, retrying in 5 secs
> [  174.771030] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> 
> The complete boot-log (captured via serial console), lspci output,
> output of hdparm -I and the kernel config are attached.
> 
> The PC has one IDE-drive and four SATA-drives (see hdparm.txt).
> If I wait long enough, the IDE-drive get's recognized and I can
> continue the boot process, but the SATA-drives are never recognized.
> The system work's fine with kernel 2.6.23.11 (later kernels not tested).

Does irqpoll kernel parameter help?

-- 
tejun
