Return-Path: <linux-kernel-owner+w=401wt.eu-S1764115AbXK3ADk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764115AbXK3ADk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761190AbXK3AD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:03:28 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46674 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbXK3AD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:03:27 -0500
Date: Thu, 29 Nov 2007 18:03:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Possibly SATA related freeze killed networking and RAID
In-reply-to: <fa.0muxGr+d7CjnQ/J5GaB+TSqouuU@ifi.uio.no>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Tejun Heo <htejun@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Message-id: <474F534A.2010500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.hz1AWBbuhaxCXiVbvWdM1r83meE@ifi.uio.no>
 <fa.fUEfthqYoWrlov4j7OjtVSgx42g@ifi.uio.no>
 <fa.qGibmi9xfm4JHJhvn0KM4rdFM+M@ifi.uio.no>
 <fa.YcQmwdppCKfJhxSMgOb0RJPmHg8@ifi.uio.no>
 <fa.0muxGr+d7CjnQ/J5GaB+TSqouuU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Tejun Heo wrote:
>> Agreed.  Nobody cared on ATA controllers is usually very effective at
>> taking the whole machine down.  Is there any reason why we don't turn on
>> irqpoll on turned off IRQs automatically?
> 
> Why does a single spurious interrupt cause it to be shut down?  I can 
> see if the interrupt is stuck on and keeps interrupting constantly, but 
> if it's just the occasional spurious interrupt, why not just ignore it 
> and move on?

I'm not certain offhand, but I think there may be such a threshold. 
However, an occasional spurious interrupt isn't likely. For a 
level-triggered interrupt, an unhandled interrupt will keep interrupting 
forever since nobody knows how to clear it (until we decide to disable 
the IRQ entirely).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

