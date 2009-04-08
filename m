Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZDHGqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZDHGqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZDHGpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:45:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57208 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZDHGpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:45:53 -0400
Message-ID: <49DC481F.4020608@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 14:45:51 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christian Pellegrin <chripell@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-rc1, build bug] Re: [PATCH 05/11] Add support for the MAX3100
 SPI UART.
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk> <20090407154840.18020.82549.stgit@t61.ukuu.org.uk> <20090408061811.GA22767@elte.hu>
In-Reply-To: <20090408061811.GA22767@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>> From: Christian Pellegrin <chripell@gmail.com>
>>
>> (akpm: queued pending confirmation of the new major number)
>>
>> [randy.dunlap@oracle.com: select SERIAL_CORE]
>> Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> ---
>>
>>  drivers/serial/Kconfig      |    7 +++++++
>>  drivers/serial/Makefile     |    1 +
>>  include/linux/serial_core.h |    3 +++
>>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> This is now upstream as:
> 
>   1dcb884: Add support for the MAX3100 SPI UART.
> 
> i'm not sure whether it has been reported already, but the new 
> driver does not even build:
> 
>    CHK     include/linux/compile.h
>  make[2]: *** No rule to make target `drivers/serial/max3100.o', needed by `drivers/serial/built-in.o'.  Stop.
>  make[1]: *** [drivers/serial] Error 2
>  make[1]: *** Waiting for unfinished jobs....

I hit the same build error just now...

> 
> ... and it has no chance to build, because the commit adds no 
> max3100.c driver file, at all.
> 
> The straight revert of 1dcb884 got the build going.
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Regards
Yang Hongyang
