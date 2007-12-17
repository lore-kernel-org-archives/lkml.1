Return-Path: <linux-kernel-owner+w=401wt.eu-S937661AbXLQX15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937661AbXLQX15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764812AbXLQX13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:27:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331AbXLQX11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:27:27 -0500
Message-ID: <476705CD.4020405@zytor.com>
Date: Mon, 17 Dec 2007 15:27:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Parag Warudkar <parag.warudkar@gmail.com>, devzero@web.de,
       Matt.Domsch@dell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
References: <49448787@web.de> <82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com> <20071216201849.24f7aa5f@the-village.bc.nu> <Pine.LNX.4.64.0712180023310.32270@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712180023310.32270@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 16 2007 20:18, Alan Cox wrote:
>>> Why tax other people with a warning/hang etc. in printk when the
>>> problem is very unlikely on their systems?
>> I think there is sense in it if you do it subtly differently.
>>
>> 	printk(".. if this hangs do ... \r");
>> 	edd_stuff();
>> 	printk("                          \r");
>> 	
>>
>> So that we display it, do the EDD call, then write over it with whatever
>> is next that matters.
> 
> Does printk support escape sequences? The last time I tried
> printk("\e[1;35m omg ponies \e[0m"); that did not went too successful.
> 

Uh, no.  Do that and anyone trying to interpret logs will beat you to 
death with a pickled herring.

	-hpa
