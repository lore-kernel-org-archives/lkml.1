Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbYESVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbYESVtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbYESVtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:49:05 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57666 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbYESVtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:49:04 -0400
Message-ID: <4831F5F7.9050900@freescale.com>
Date: Mon, 19 May 2008 16:49:43 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Rune Torgersen <runet@innovsys.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Oops with PREEMPT-RT on 2.6.25.4
References: <DCEAAC0833DD314AB0B58112AD99B93B0469010C@ismail.innsys.innovsys.com>	<4831D527.2020907@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690162@ismail.innsys.innovsys.com> <4831ECF0.5090101@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690239@ismail.innsys.innovsys.com> <4831F364.8020702@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690276@ismail.innsys.innovsys.com>
In-Reply-To: <DCEAAC0833DD314AB0B58112AD99B93B04690276@ismail.innsys.innovsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rune Torgersen wrote:
> Scott Wood wrote:
>> Try calling irq_set_chip_and_handler() with handle_level_irq, rather
>> than irq_set_chip().  The -rt patch doesn't seem to have threadified
>>   the __do_IRQ() path.
> 
> The demuxer is setting itself up with set_irq_chained handler(), any
> pointers on how to change to irq_set_chip_and_handler()?

No, I mean the call to set_irq_chip() in pci_pic_host_map() where it 
sets up the IRQs it manages, not the cascade IRQ itself.

-Scott
