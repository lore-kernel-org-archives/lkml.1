Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYBBLUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYBBLUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYBBLUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:20:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:37370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYBBLUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=imUxqEVdBGm2NzN5uuw475uzqHQjO4cnQMrO1/GcJ3JbvzrVZtZyyq0c/ftGCdiQ+ZzbQDpnb26efPp8cgJCc83C/BAFl6lvTzNufpqNYtzuClqOSEDZi2VgnLR3BOLcidhBQ7LLD1vk/DVv0UtSZfiH+Bk5jMunvIUTwJpfMjw=
Message-ID: <47A451E6.5030305@gmail.com>
Date: Sat, 02 Feb 2008 20:20:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mao Rui <maorui@yuvad.com>
CC: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: SATA DOM is not identified by ata_piix module
References: <001e01c8657d$8c839490$7740a8c0@cmaorui2>
In-Reply-To: <001e01c8657d$8c839490$7740a8c0@cmaorui2>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mao Rui wrote:
> Hi,
> 
> No difference... :-(
> 
> Here is the log.
> 
> [   26.729011] scsi0 : ata_piix
> [   26.729067] scsi1 : ata_piix
> [   26.729095] ata1: SATA max UDMA/133 cmd 0x1880 ctl 0x1874 bmdma 0x1860
> irq 18
> [   26.729097] ata2: SATA max UDMA/133 cmd 0x1878 ctl 0x1870 bmdma 0x1868
> irq 18
> [   26.894043] ata1.00: ATA-6: WDC WD2500SD-01KCB0, 08.02D08, max UDMA/133
> [   26.894046] ata1.00: 488397168 sectors, multi 16: LBA48
> [   26.910218] ata1.00: configured for UDMA/133
> [   57.043651] ata2.00: qc timeout (cmd 0x91)
> [   57.043656] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x4)
> [   57.043659] ata2: failed to recover some devices, retrying in 5 secs
> [   92.177684] ata2.00: qc timeout (cmd 0x91)
> [   92.177688] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x4)

Ah.. Timeout.  Hmmm... Interesting.  Maybe the device just should be
blacklisted such that INIT_DEV_PARAMS is not issued.  Can you please
just comment out the INIT_DEV_PARAMS block and see how it works and post
full boot log?

-- 
tejun
