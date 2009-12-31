Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZLaRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZLaRtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 12:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZLaRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 12:49:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61565 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZLaRtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 12:49:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WchtdUDy303oAkTqUTrSrz+tCCcu31WuZ+DIcX+YlPonc25P7qK7qpgNywc/6I2YYO
         8QluSuobWfmvEairCnJpNiu81klYxJFWKfeE+vaJJ6y7YfUIS6mafGh7EdAQXW/ZjYRD
         h9ethI0l/Gk762AnRL3RTYlOb0351Q1RQ7RQ8=
MIME-Version: 1.0
In-Reply-To: <4B3CD221.1090402@tmr.com>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
	 <4B3C1137.8060308@tmr.com> <4B3C5F22.1080108@panasas.com>
	 <4B3CD221.1090402@tmr.com>
Date: Thu, 31 Dec 2009 17:49:18 +0000
Message-ID: <74fd948d0912310949g129750d5xea23ded8ae3f525a@mail.gmail.com>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
From: Pedro Ribeiro <pedrib@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 4:32 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Boaz Harrosh wrote:
>>
>> On 12/31/2009 04:49 AM, Bill Davidsen wrote:
>>>
>>> Yuhong Bao wrote:
>>>>
>>>> Given that Linus was once talking about the performance penalties of PAE
>>>> and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of
>>>> interest:
>>>> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
>>>>
>>> I find these tests mirror my own experience with PAE, the benefit of
>>> having the nx hardware enabled justifies the few percent drop in performance
>>> I was able to find.
>>>
>>> I find the huge gain in web service hard to believe without a hint why a
>>> 64 bit CPU would be 15x faster. The disk, memory, and network wouldn't be
>>> faster, and the CPU intensive tests weren't significantly faster, so unless
>>> the systems were tuned differently where's the gain? Same feeling about the
>>> TP test, an order of magnitude faster on a test running the same application
>>> on the same hardware is hard to buy without an explanation.
>>>
>>
>> Why? simple, Memory. This system must have lots of memory (see the
>> HIGHMEM64G) so
>> lots of IO must be bouncing on a 32bit system, where in 64bit it is
>> copy-less.
>>
> Did you miss the hardware configuration? It was run on a laptop with 4GB and
> two little laptop drives. And there was no serious difference between the
> non-PAE (sees 3GB) and PAE (sees 4GB) performance. Clearly there's little
> enough memory to address in any mode.
>
>> Just my guess, but I'm not surprised.
>>
> Eight thousand pages/sec out of a laptop with 5400 rpm drives doesn't
> surprise you? Even if every page were copied to somewhere else the speed of
> the disk and network are still 1000 times slower. I haven't found details on
> this "test" but I'm guessing that the pages are all in memory so the disk is
> only used once, maybe even the same page being read each time, and if the
> client is on the same machine the "network" is loopback. Not representative
> of much of anything in the general case, that.
>
>>> The only obvious source I can think of is running the test load at
>>> 100Mbit on
>>> one test and Gbit on another, because I saw an early network driver do
>>> just that
>>> in negotiations with a switch.
>>>
>
>
> --
> Bill Davidsen <davidsen@tmr.com>
>  "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

The article doesn't mention if a 64-bit kernel with 32-bit userland
was used or a 64-bit kernel with 64-bit userland.

Is there any performance benefit in having the former?

Regards,
Pedro
