Return-Path: <linux-kernel-owner+w=401wt.eu-S1761852AbXGJTI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852AbXGJTI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXGJTIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:08:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:16039 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752852AbXGJTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:08:45 -0400
Message-ID: <4693D9B6.4090408@ru.mvista.com>
Date: Tue, 10 Jul 2007 23:10:46 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
References: <20070221011922.GA1777@freefall.freebsd.org> <200702210342.20775.bzolnier@gmail.com> <466EEFD6.9030001@ru.mvista.com> <200706160123.55636.bzolnier@gmail.com>
In-Reply-To: <200706160123.55636.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>>On Feb 20, 2007, at 5:44 PM, Bartlomiej Zolnierkiewicz wrote:

>>>>>On Wednesday 21 February 2007 02:19, Suleiman Souhlal wrote:

>>>>>>It can be changed via /proc/ide/hd?/settings.

>>>>>Why do we need to change IDE DMA timeout dynamically?

>>>>I've used it to test error recovery (for example).

>>>Seems quite useable for developers but I would prefer not to
>>>expose it in production kernels for end users.

>>    It seems that I have counter example of a customer asking if this timeout 
>>can be done configurable. :-)

> May I ask what was the rationale for this request?

    Their system seems to become unschedulable for this period of time (DMA 
timeouts happen from time to time) -- at least the keepalive daemon stopped 
replying during this period...

> I have no strong feelings about adding this /proc/ide/ setting but I worry
> that it could be (mis)used just to (unreliably) work-around problems...

>>    BTW, why the timeout is so damn long? 2*WAIT_CMD is 20 secs, and if DMA is 
>>not complete or interrupt pending, it may wait 10 more secs...

> I really don't remember... :)

> Maybe Mark or Alan could help with figuring this out.

    They also have probably forgotten. :-)

> Thanks,
> Bart

MBR, Sergei
