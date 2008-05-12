Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYELRGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYELRGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYELRGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:06:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47616 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbYELRGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:06:36 -0400
Message-ID: <48287916.2090203@pobox.com>
Date: Mon, 12 May 2008 13:06:30 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers/net: remove null pointer dereference
References: <Pine.LNX.4.64.0805121537320.3694@ask.diku.dk> <20080512161734.GA22190@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0805121852510.16384@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0805121852510.16384@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> On Mon, 12 May 2008, Francois Romieu wrote:
> 
>> Julia Lawall <julia@diku.dk> :
>> [...]
>>> diff -u -p a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
>>> --- a/drivers/net/au1000_eth.c	2008-04-27 11:41:11.000000000 +0200
>>> +++ b/drivers/net/au1000_eth.c	2008-05-12 09:32:54.000000000 +0200
>>> @@ -1242,7 +1242,7 @@ static irqreturn_t au1000_interrupt(int 
>>>  	struct net_device *dev = (struct net_device *) dev_id;
>>>  
>>>  	if (dev == NULL) {
>>> -		printk(KERN_ERR "%s: isr: null dev ptr\n", dev->name);
>>> +		printk(KERN_ERR "isr: null dev ptr\n");
>>>  		return IRQ_RETVAL(1);
>>>  	}
>> The lifespan of 'dev' covers the request_irq..free_irq interval in this
>> driver. The whole 'dev == NULL' block can be removed.
> 
> Will you do that?

It's normal within the Linux community to give feedback on patches, and 
sometimes the authors need to revise their patches if helpful feedback 
arises.

	Jeff



