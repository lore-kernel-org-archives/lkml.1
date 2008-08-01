Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYHAHpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYHAHpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYHAHpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:45:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbYHAHpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:45:06 -0400
Message-ID: <4892BEBA.2000602@kernel.org>
Date: Fri, 01 Aug 2008 16:43:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: gshan <gshan@alcatel-lucent.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com>	<488F1C6C.9000002@garzik.org>	<48902EB5.8070102@alcatel-lucent.com> <20080730114934.5a593cf4@lxorguk.ukuu.org.uk> <48913FFD.5070901@alcatel-lucent.com>
In-Reply-To: <48913FFD.5070901@alcatel-lucent.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 Aug 2008 07:44:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gshan wrote:
> 
>>> Another question is my PIIX4 chip has device ID + vendor ID of
>>> 0x71108086. But it finally
>>> was mapped to following ID of piix_pci_tbl[] array. Device of 0x7110
>>> and 0x7010 should
>>> be quit different, right?
>>>     
>>
>> Yes - I find tht one very odd - you might need to debug a bit to see what
>> is occuring if you think this is the case.
>>
>> Alan
>>   
> Alan/Jeff, I tried to install ATA driver on PIIX4. After fixing IRQ number
> to 143 for primary and secondary channel. I got following output and
> it seems the driver has been loaded sucessfully. However, I couldn't
> see any information from /proc/devices. Do you have any ideas?

You need the SCSI disk driver - sd_mod.ko.

-- 
tejun
