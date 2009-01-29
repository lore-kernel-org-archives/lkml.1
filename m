Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbZA2Axp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbZA2Axp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbZA2AxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:53:00 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6110 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158AbZA2Aw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:52:58 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=DjLEaWCWrnxvQpmzrYwA:9 a=DwfF2HS221eC2nkUGMW3wj7OmCoA:4 a=px7WpBMsk_MA:10 a=FkNknbw5k8MA:10
Message-ID: <4980FDE6.7080406@shaw.ca>
Date: Wed, 28 Jan 2009 18:52:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.ide,gmane.linux.kernel
To: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Seagate disk freeze for 30 seconds then comes back (RecovComm
   10B8B)
References: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro>
In-Reply-To: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin(ux) M. BOIE wrote:
> Hello!
> 
> I have a ST9160821AS drive, firmware 3.BHE, and I experience some seldom 
> problems with it. It is in a HP 6715s HP laptop, kernel 2.6.27.5.
> 
> The error message is:
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x80002 action 0x6 frozen
> ata1: SError: { RecovComm 10B8B }
> ata1.00: cmd ca/00:f8:11:b8:38/00:00:00:00:00/ec tag 0 dma 126976 out
> res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: hard resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
> ata1.00: configured for UDMA/100
> ata1: EH complete
> sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> 
> When it happens, the system freezes for around 30 seconds.
> 
> Seagate told me that there is no firmware update for this drive.
> 
> Please, let me know if it is a software issue.

Quite unlikely, it looks like something caused the communications with 
the drive to be dropped. It's likely either a drive, cabling/connection 
or power problem (the latter two seem unlikely in a laptop though, 
unless the drive isn't connected all the way or something..)
