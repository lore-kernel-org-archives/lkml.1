Return-Path: <linux-kernel-owner+w=401wt.eu-S936608AbXGMPT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936608AbXGMPT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbXGMPTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:19:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:44334 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755575AbXGMPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:19:33 -0400
Message-ID: <4697987E.3040406@ru.mvista.com>
Date: Fri, 13 Jul 2007 19:21:34 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <20070221011922.GA1777@freefall.freebsd.org>	<200702210342.20775.bzolnier@gmail.com>	<466EEFD6.9030001@ru.mvista.com>	<200706160123.55636.bzolnier@gmail.com>	<4693D9B6.4090408@ru.mvista.com> <20070713161612.2f2ebb0b@the-village.bc.nu> <46979652.6040201@rtr.ca>
In-Reply-To: <46979652.6040201@rtr.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mark Lord wrote:

>> O> >>    BTW, why the timeout is so damn long? 2*WAIT_CMD is 20 secs, 
>> and if DMA is

>>>>> not complete or interrupt pending, it may wait 10 more secs...
>>>>
>>>> I really don't remember... :)
>>>> Maybe Mark or Alan could help with figuring this out.

>>>     They also have probably forgotten. :-)

>> Because that value seemed to work ok. Mark set the timeouts way back in
>> history and I never touched most of them.
> 
> 
> I've lost the original question from this thread, but the idea of the 

    The original question concerned specifically the DMA command timeout which 
is twice more than the usual one, WAIT_CMD (10 seconds).

> longish
> timeouts was that drive *may* be spun down ("standby"), and thus have to 
> spin
> up again to complete media commands.  Back then, drives were much slower at
> spinning up than nowadays, and the ATA spec says to allow up to 30 seconds.

    Well, that doesn't explain the DMA case.

MBR, Sergei
