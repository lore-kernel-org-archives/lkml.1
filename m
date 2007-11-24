Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbXKXNLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbXKXNLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 08:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXKXNL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 08:11:27 -0500
Received: from rayleigh.systella.fr ([213.41.184.253]:34915 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbXKXNL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 08:11:26 -0500
Message-ID: <474822F3.6070803@systella.fr>
Date: Sat, 24 Nov 2007 14:11:15 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.9) Gecko/20071030 Iceape/1.1.6 (Debian-1.1.6-2)
MIME-Version: 1.0
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NETDEV WATCHDOG (3Com 3c905 adapter)
References: <4746C44B.8040008@systella.fr> <4746F747.4010906@systella.fr> <20071124111425.GA29778@newton.mathematik.tu-chemnitz.de>
In-Reply-To: <20071124111425.GA29778@newton.mathematik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Sat, 24 Nov 2007 14:11:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steffen Klassert wrote:
> On Fri, Nov 23, 2007 at 04:52:39PM +0100, BERTRAND Joël wrote:
>> BERTRAND Joël wrote:
>>>    Hello,
>>>
>>>    Since I have installed a 2.6.23.1 linux kernel on my U60, I can see 
>>> several NETDEV WATCHDOG. This trouble never occurs with 2.6.23-rc4.
>>> This bug occurs after a random uptime.
>> 	I have made the same constation this evening on a amd64/up with two 
>> 3C905 and a 2.6.21.3 linux kernel... This evening, I have rebooted my 
>> U60 with a 2.6.23.8 kernel and the same 3C905 runs fine. Wait and see 
>> (but I suspect a kernel bug...).
>>
>> 	For main linux kernel list:
>>
>>> End of dmesg :
>>>
>>> NETDEV WATCHDOG: eth2: transmit timed out
>>> eth2: transmit timed out, tx_status 00 status 8601.
>>>  diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
>>> eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
> 
> This looks like a problem that several network drivers had recently.
> The problem was genirq related and should be fixed in 2.6.23,
> so I'm surprised that this happens with 2.6.23.1 but not with 2.6.23-rc4.

	I can confirm that my U60 worked fine sixty days with 2.6.23-rc4 
without any trouble. With 2.6.23.1, 3com NIC hangs after three or four 
days...

	Regards,

	JKB
