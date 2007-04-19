Return-Path: <linux-kernel-owner+w=401wt.eu-S637738AbXDSMEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637738AbXDSMEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993255AbXDSMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:04:12 -0400
Received: from smtpout09-04.prod.mesa1.secureserver.net ([64.202.165.17]:54004
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S2993254AbXDSMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:04:11 -0400
Message-ID: <46275AB8.5010800@seclark.us>
Date: Thu, 19 Apr 2007 08:04:08 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.21-rc5 from fc7-rc2 problems
References: <460EC109.5070300@seclark.us>	<460EFC76.4060808@seclark.us>	<460FF40D.2060109@seclark.us>	<200704181612.07257.lenb@kernel.org>	<46267E38.9020909@garzik.org> <20070418215039.683f80ee@the-village.bc.nu>
In-Reply-To: <20070418215039.683f80ee@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>>>scsi0 : pata_ali
>>>>PM: Adding info for No Bus:host0
>>>>ata1.00: ATA-5: HITACHI_DK23CA-20, 00H1A0A3, max UDMA/100   <========
>>>>drive can do 100
>>>>ata1.00: 39070080 sectors, multi 16: LBA
>>>>ata1.00: configured for UDMA/33    <=============== configured as 33
>>>>        
>>>>
>
>How is this system actually set up - what cable is used on that drive ?
>
>  
>
>>>>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>>>ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 36 in
>>>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>>ata2: soft resetting port
>>>>        
>>>>
>>It looks like interrupts are not being delivered?
>>    
>>
>
>We still have a problem with pata_ali and ATAPI. I'm still trying to work
>out wtf is going on there as I can't find any meaningful difference and
>even some paranoid 'assume the worst of the comments in the databook'
>additional code isn't helping.
>
>  
>
Hi,

This is a laptop with both the cd and hardrive connected directly to the 
mainboard. The key is
they both work correctly under 2.6.20.

HTH,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



