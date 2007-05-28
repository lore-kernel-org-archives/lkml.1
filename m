Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbXE1PbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbXE1PbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXE1PbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:31:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46953 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbXE1PbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:31:01 -0400
Date: Mon, 28 May 2007 17:30:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Message-ID: <20070528153055.GN3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 08:10:31PM +0530, Nitin Gupta wrote:
> Hi,
>
> Attached is tester code used for testing.
> (developed by Daniel Hazelton -- modified slightly to now use 'take 6'
> version for 'TinyLZO')
>
> Cheers,
> Nitin
>
> On 5/28/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
>> (Using tester program from Daniel)
>>
>> Following compares this kernel port ('take 6') vs original miniLZO code:
>>
>> 'TinyLZO' refers to this kernel port.
>>
>> 10000 run averages:
>> 'Tiny LZO':
>>        Combined: 61.2223 usec
>>        Compression: 41.8412 usec
>>        Decompression: 19.3811 usec
>> 'miniLZO':
>>        Combined: 66.0444 usec
>>        Compression: 46.6323 usec
>>        Decompression: 19.4121 usec
>>
>> Result:
>> Overall: TinyLZO is 7.3% faster
>> Compressor: TinyLZO is 10.2% faster
>> Decompressor: TinyLZO is 0.15% faster

So your the compressor of your version runs 10.2% faster than the 
original version.

That's a huge difference.

Why exactly is it that much faster?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

