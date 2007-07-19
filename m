Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXGSLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXGSLnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXGSLnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:43:09 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:50081 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbXGSLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:43:08 -0400
Message-ID: <469F4E47.4020809@grupopie.com>
Date: Thu, 19 Jul 2007 12:43:03 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: koan <koan00@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow Soft-RAID 5 performance
References: <64d833020707180707i1bbbbcbao783e33a2487c9e2b@mail.gmail.com>	 <469E4A70.1000306@grupopie.com> <64d833020707181107o705ff16ava129e91fcf68a8ef@mail.gmail.com>
In-Reply-To: <64d833020707181107o705ff16ava129e91fcf68a8ef@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

koan wrote:
> Are you sure about that chunk size? In you initial posting you show
> /proc/mdstat reporting:
>
> "md2 : active raid5 sdc3[2] sda3[0] sdb3[1]
>      780083968 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]"
>
> Which would seem to state a 128K chunk, and thus with a 4k block size
> you would need a stride of 32.

Hi Koan,

Yes, I'm sure... Those 128K chunk was my initial setup, before the
enlightenment from http://tldp.org/HOWTO/Software-RAID-HOWTO-5.html
My reported test setup is by using 256K chunk.

>
>
>
> On 7/18/07, Rui Santos <rsantos@grupopie.com> wrote:
>> koan wrote:
>> > How did you create the ext3 filesystem?
>>
>> The chunk_size is at 256KB, ext3 block size is 4k. I believe the correct
>> option that should be passed trough to --stride is 64.
>> Am I correct ?
>>
>> I've also tested ( after sending my first report ) with xfs.
>> I've also increases readahead to 65535 on all HD's
>> I've also increases the stripe_cache_size to 16384.
>>
>> I can now get ~100MB/sec...
>>
>> >
>> > Did you use the appropriate --stride option as noted here:
>> > http://tldp.org/HOWTO/Software-RAID-HOWTO-5.html (#5.11)
>> > -
>> > To unsubscribe from this list: send the line "unsubscribe
>> > linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>> >
>> >
>>
>>
>
>
>

