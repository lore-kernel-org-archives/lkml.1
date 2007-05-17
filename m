Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbXEQImn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbXEQImn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXEQImf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:42:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:12157 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbXEQIme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RcSf6zaqlfahGqQp++1OuNOTE8WL4TdAPSwRdyvuB50MBseocUzYqjNeSdabbyopc4TfRwHvpvD0ALsrXx2sDdK3vBpOAISQ6h2Jqem+DshEDuWk6YsMDkZNp2FI0Q6LBtUXl+wsG2/onDQfzTX7eQSlSlzJkH0+hwDDxqXHJ18=
Message-ID: <464C1575.8070005@gmail.com>
Date: Thu, 17 May 2007 10:42:29 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, alan@redhat.com
CC: jgarzik@pobox.com
Subject: Re: libata pcmcia failure
References: <464A0321.3080201@gmail.com>
In-Reply-To: <464A0321.3080201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I installed the LiveCD to a spare HDD, and updated to the latest kernel 
available.
The errors stayed the same, but they took much longer (it seems the 
timeouts changed).

Linux localhost.localdomain 2.6.21-1.3149.fc7 #1 SMP Fri May 11 12:12:11 
EDT 2007 i686 i686 i386 GNU/Linux

May 16 23:10:42 localhost kernel: pccard: PCMCIA card inserted into slot 0
May 16 23:10:42 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
May 16 23:10:42 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
May 16 23:10:42 localhost kernel: pcmcia: registering new device pcmcia0.0
May 16 23:10:42 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 ctl 
0x0001410e bmdma 0x00000000 irq 3
May 16 23:10:42 localhost kernel: scsi2 : pata_pcmcia
May 16 23:11:43 localhost kernel: ata3.00: qc timeout (cmd 0x91)
May 16 23:11:43 localhost kernel: ata3.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
May 16 23:12:44 localhost kernel: ata3.00: qc timeout (cmd 0x91)
May 16 23:12:44 localhost kernel: ata3.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)
May 16 23:12:44 localhost kernel: ata3.00: limiting speed to UDMA7:PIO5
May 16 23:13:14 localhost kernel: ATA: abnormal status 0x82 on port 
0x00014107
May 16 23:13:14 localhost kernel: ATA: abnormal status 0x82 on port 
0x00014107
May 16 23:13:44 localhost kernel: ata3.00: qc timeout (cmd 0x91)
May 16 23:13:44 localhost kernel: ata3.00: failed to IDENTIFY 
(INIT_DEV_PARAMS failed, err_mask=0x4)

Robert de Rooy wrote:
> Hi,
>
> I tried Fedora 7t4 LiveCD on my ThinkPad T41 with a PCMCIA "Dazzle 
> 4in1 Card Adapter", this adapter supports Sony Memorystick, MMC, SD 
> and SmartMedia cards. The card had a 128MB Lexmark MemoryStick installed.
>
> Under windows the adapter works fine, but under Linux I got a bunch of 
> errors in syslog as shown below...
> I do not know if it works with the Linux legacy PCMCIA IDE driver.
>
> If I need to retrieve additional information or test something, please 
> let me know.
>
> Linux localhost.localdomain 2.6.20-1.3104.fc7 #1 SMP Sat Apr 21 
> 22:20:43 EDT 2007 i686 i686 i386 GNU/Linux
>
> Socket 0:
>  product info: "                   ", "Memory Card Adapter", "", ""
>  manfid: 0x0045, 0x0401
>  function: 4 (fixed disk)
>
> May 14 21:46:24 localhost kernel: pccard: PCMCIA card inserted into 
> slot 0
> May 14 21:46:24 localhost kernel: cs: memory probe 
> 0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
> May 14 21:46:24 localhost kernel: cs: memory probe 
> 0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
> 0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
> 0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
> 0xcfa00000-0xd01fffff
> May 14 21:46:24 localhost kernel: pcmcia: registering new device 
> pcmcia0.0
> May 14 21:46:25 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 
> ctl 0x0001410e bmdma 0x00000000 irq 3
> May 14 21:46:25 localhost kernel: scsi3 : pata_pcmcia
> May 14 21:46:25 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:46:25 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:46:55 localhost kernel: ata3.00: qc timeout (cmd 0x91)
> May 14 21:46:55 localhost kernel: ata3.00: failed to IDENTIFY 
> (INIT_DEV_PARAMS failed, err_mask=0x4)
> May 14 21:46:56 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:46:56 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:47:26 localhost kernel: ata3.00: qc timeout (cmd 0x91)
> May 14 21:47:26 localhost kernel: ata3.00: failed to IDENTIFY 
> (INIT_DEV_PARAMS failed, err_mask=0x4)
> May 14 21:47:26 localhost kernel: ata3.00: limiting speed to UDMA7:PIO5
> May 14 21:47:26 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:47:26 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:47:56 localhost kernel: ata3.00: qc timeout (cmd 0x91)
> May 14 21:47:56 localhost kernel: ata3.00: failed to IDENTIFY 
> (INIT_DEV_PARAMS failed, err_mask=0x4)
> May 14 21:47:57 localhost kernel: ATA: abnormal status 0x80 on port 
> 0x00014107
> May 14 21:47:57 localhost udevd-event[3946]: udev_rules_apply_format: 
> unknown format variable '$modalias'
>
>
>

