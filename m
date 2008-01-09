Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYAIBuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYAIBuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYAIBuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:50:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:32247 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYAIBuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:50:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WjH7xNRbUZPnb/A1ftyvMKMVkM24t02MpY6rUKa1H+cK56r/0f5FiwVvhQS6PNjV11oqiLysrcP5Dlhw41+8g6dlvam2beQBMJ0e2xaEkhAm0dDu+bDiXu5J5QAPlv/+S7iMXD8YdPPIxEcC1fbAwzKQoPfwsDE0cu5kTYCukLs=
Message-ID: <47842842.9090805@gmail.com>
Date: Wed, 09 Jan 2008 10:49:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [Re: Linux 2.6.24-rc7] ata1: exception Emask 0x10 SAct 0x0 SErr
 0x0 action 0x9 t4
References: <8db1092f0801080826s44582801s2dbacd02f30c7240@mail.gmail.com>
In-Reply-To: <8db1092f0801080826s44582801s2dbacd02f30c7240@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> I have this message when resume from suspend to disk:
> 
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: MWDMA2 mode selected
> sd 0:0:0:0: [sda] Starting disk
> [...]
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
> ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
> ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
> ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
> ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> ata1.00: configured for UDMA/133
> ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
> ata1: irq_stat 0x00400040, connection status changed
> ata1.00: configured for UDMA/133
> ata1: EH complete
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> 
> Suspend to disk works fine without any problems.

Those are newly added ACPI command filtering and KERN_DEBUG messages.
As we're following what BIOS is telling us, we definitely want to filter
and log what rubbish it tells us.  :-)

Thanks.

-- 
tejun
