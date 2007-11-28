Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXK1Bzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXK1Bzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbXK1Bza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:55:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:30687 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbXK1Bz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PvKnjA1CnjAEe7txuWzC8HVb49bXxvQ5daJjvuE8Rt0RJHBlwCv9pAE1bvav+b3l67ARUSdJiUtw4QUke1xVfoEVCbg5xplLG+2NXEQRU4KyGEECS9ELM5P//LHU2MCL2cv3NUWWRPwWMPbrdVjgiz4YRYtxJd5PVZ/6xA4/McU=
Message-ID: <474CCA82.7030000@gmail.com>
Date: Wed, 28 Nov 2007 10:55:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz>
In-Reply-To: <20071126120649.GC4701@ucw.cz>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>  kernel: [734344.717844] irq 21: nobody cared (try booting with the
>>> "irqpoll" option)
>>>  kernel: [734344.717866]
>> Your machine decided to emit interrupt 21 without an apparent reason.
>> Whatever caused that made the kernel shut down IRQ 21 at which point the
>> disk drives on that IRQ were no longer being serviced. Everything on IRQ
>> 21 would have died - which may be why your networking failed too.
> 
> Hmm, perhaps that 'nobody cared' message should be worded more
> strongly, and printed and KERN_CRIT?

Agreed.  Nobody cared on ATA controllers is usually very effective at
taking the whole machine down.  Is there any reason why we don't turn on
irqpoll on turned off IRQs automatically?

Thanks.

-- 
tejun
