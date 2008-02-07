Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYBGQbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYBGQbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYBGQav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:30:51 -0500
Received: from smtp23.orange.fr ([193.252.22.126]:4447 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbYBGQau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:30:50 -0500
X-ME-UUID: 20080207163029826.1419D701799B@mwinf2327.orange.fr
Message-ID: <47AB321E.5080908@cosmosbay.com>
Date: Thu, 07 Feb 2008 17:30:22 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Marcin Koziej <marcinkoziej@o2.pl>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Bug? Kernels 2.6.2x drops TCP packets over wireless (independent
 of card used)
References: <56de948.2f1b076b.47aac980.bfd66@o2.pl> <6101e8c40802070623t55115dc3h4cf508e432b9296f@mail.gmail.com> <776aaa6c.68622465.47ab2df0.78e4b@o2.pl>
In-Reply-To: <776aaa6c.68622465.47ab2df0.78e4b@o2.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Koziej a écrit :
>> hmm, i think, the site is broken (193.219.28.140), and not the card or
>> the driver is wrong. when it does, then other sites are auch
>> reproductable ..
>>
>> /* is use auch madwifi-0.9.3.3, but it think, it is not driver problem */
>>     
>
> Unfortunately, this is not the case :(  This happens to all TCP connections, inside and outside LAN,
> also with the telnet session with the router. I also tried to manipulate MTU, but without any positive effect.
> I also tried to change things like net.ipv4.tcp_congestion_control -- which i figured out might affect TCP traffic, but also didn't get any results.
> I'm afraid this can have something to do with IRQ, because the PCMCIA cards (my Atheros wireless card is such) are visible only with irqpoll kernel option.
>
> Of course, as I mentioned, everything works fine with kernel 2.6.19; with the same servers etc.
>
>   
Very strange, as the tcpdump you gave shows that the remote peer only 
sent "220-\r\n"

This was ACKed, and then nothing but timeout. We can conclude remote 
peer is *very* slow or a firewall is blocking trafic after 6 bytes sent :)

Could you give a tcpdump for the same destination, on 2.6.19 this time ?





