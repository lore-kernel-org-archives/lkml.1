Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbXIFCUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbXIFCUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 22:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbXIFCUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 22:20:42 -0400
Received: from rtr.ca ([76.10.145.34]:4484 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbXIFCUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 22:20:41 -0400
Message-ID: <46DF63F8.8070805@rtr.ca>
Date: Wed, 05 Sep 2007 22:20:40 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Tejun Heo <htejun@gmail.com>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH Intel PATA short cable override...
References: <6278d2220709040537n4c96ffcagd9c25c94ddd29ca1@mail.gmail.com> <20070906014209.142382c8@the-village.bc.nu>
In-Reply-To: <20070906014209.142382c8@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 4 Sep 2007 13:37:22 +0100
> "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> 
>> We see that in ata_piix.c, there is a whitelist for (laptop) Intel ICH
>> controllers with short cables, tied to specific vendor subsystem IDs.
>> Since my mini-ITX Ibase MI910F has the subsystem IDs specified as
>> Intel [1], this is unusable.
>>
>> I can't find another existing mechanism to add short cable
>> information, to allow UDMA/66 for my on-board CF socket.
> 
> DMI is the other approach (if your box has sane responses to the
> dmidecode command we can do this). 

No, something more flexible is needed here.

For example, I have a Mini-ITX server here, which I personally have
equipped with a 3" 40W IDE cable that connects to a notebook drive.

The system currently uses UDMA just fine with the IDE drivers,
but I have not been able to convert it to use the (stock) libata drivers
because of this silly lack of end-user control.

We really need an override for this -- embedded folks would also apprecaate one.
Ditto for selecting transfer modes.

Cheers
