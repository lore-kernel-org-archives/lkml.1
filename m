Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYIORPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYIORPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYIORPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:15:07 -0400
Received: from mail.tmr.com ([64.65.253.246]:56009 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYIORPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:15:05 -0400
Message-ID: <48CE97BA.1060901@tmr.com>
Date: Mon, 15 Sep 2008 13:13:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
CC: Rob Landley <rob@landley.net>, Willy Tarreau <w@1wt.eu>,
       Alain Knaff <alain@knaff.lu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>	 <20080907054831.GA2244@1wt.eu> <200809142037.48204.rob@landley.net> <ac9c93b10809150546w7644316bk53122b0ce5021ff4@mail.gmail.com>
In-Reply-To: <ac9c93b10809150546w7644316bk53122b0ce5021ff4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Meulenbroeks wrote:
> 2008/9/15 Rob Landley <rob@landley.net>:
>> On Sunday 07 September 2008 00:48:31 Willy Tarreau wrote:
>>> Hi Alain,
>>>> +config KERNEL_LZMA
>>>> +       bool "LZMA"
>>>> +       help
>>>> +         The most recent compression algorithm.
>>>> +    Its ratio is best, decompression speed is between the other
>>>> +    2. Compression is slowest.
>>>> +    The kernel size is about 33 per cent smaller with lzma,
>>>> +    in comparison to gzip.
>>> isn't memory usage in the same range as bzip2 ?
>> Last I checked it was more.  (I very vaguely recall somebody saying 16 megs
>> working space back when this was first submitted to busybox, but that was a
>> few years ago...)
>>
>> A quick Google found a page that benchmarks them.  Apparently it depends
>> heavily on which compression option you use:
>>
>> http://tukaani.org/lzma/benchmarks
>>
> 
> [...]
> 
> Apologies if I'm sidetracking the discussion, but I'd like to coin a remark.
> 
> For kernel/ramfsimage etc the best choice is the one that has the
> fastest decompression (info on tukaani.org says gzip).
> Rationale: as it uncompresses faster the system will boot faster.
> 
> Of course this only holds if the background memory can hold that
> image. For disk based systems, I assume this is not a problem at all,
> but for embedded systems with all software in flash a higher
> compression ration (e.g. lzma) can just make the difference between
> fit and not fit (so in those cases lzma could just make your day).
> 
Given the larger memory needed to decompress, it becomes a very interesting 
calculation in really small memory machines.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
