Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbYEBAaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbYEBAaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYEBAaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:30:07 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:17157 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbYEBAaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:30:05 -0400
Message-ID: <481A6080.8090307@googlemail.com>
Date: Fri, 02 May 2008 02:29:52 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804290352.33543.yhlu.kernel@gmail.com>	 <200804292025.58268.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com>	 <4819AD44.4040200@googlemail.com> <86802c440805011706m51f4840dye0191c7e853d5aa@mail.gmail.com>
In-Reply-To: <86802c440805011706m51f4840dye0191c7e853d5aa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2008 00:23:09.0098 (UTC) FILETIME=[B2D3C8A0:01C8ABEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, May 1, 2008 at 4:45 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Yinghai Lu wrote:
>>  > loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
>>  >
>>  > so user don't need to add mtrr_chunk_size and mtrr_gran_size,
>>  >
>>  > if optimal value is not found, print out all list to help select less optimal
>>  > value.
>>  >
>>  > add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
>>
>>  WOW :)
>>
>>  With this patch all is working fine , no RAM is lost , X is fast ,
>>  so far everything else seems to work fine. \o/
>>
>>  I will test on 32bit tomorrow and stress the box later on today to be sure everything works fine.
>>
>>  There is my dmesg , meminfo , mtrr output with this patch on top x86-latest :
>>
>>  http://frugalware.org/~crazy/mtrr_x86-latest/
> 
> while look at that you boot log, it seems there is one bug about hole
> position. but I look that code, it should already be handled.
> 
> Can you send out boot msg and /proc/mtrr when using
> disable_mtrr_cleanup command line?

Sure , there it is :

http://frugalware.org/~crazy/mtrr_x86-latest/dmesg2
http://frugalware.org/~crazy/mtrr_x86-latest/proc_mtrr2

I'm still using this version of your patch , didn't got any time to update to v2.
If you want me to try v2 tell me , I have some free time in about 30 minutes.

> 
> Thanks
> 
> Yinghai Lu
> 

Gabriel
