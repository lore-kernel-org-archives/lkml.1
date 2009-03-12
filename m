Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZCLLjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZCLLjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZCLLiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:38:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:56057 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZCLLit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ElC/u8Pg0s2hrA1zy+JufMXqZg87kajh6fmSIGK/wzWcQvSkB8ZHFVfXs2aEd2SoD5
         RhJVo1C+pPZqmnAzNxb4ZzIaTu7KEA4/8pNCm+ED+kNhNkfq+3th4kINrHy8k3dB3q9F
         YZAQYD6ENKFDBoNAjmmoHJDf9NAZLuKQnsWF0=
MIME-Version: 1.0
In-Reply-To: <20090312103847.GA20210@localhost>
References: <20090311114353.GA759@localhost> <20090311121123.GA7656@localhost>
	 <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
	 <20090311122611.GA8804@localhost>
	 <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
	 <20090312075952.GA19331@localhost>
	 <e2dc2c680903120104h4d19a3f6j57ad045bc06f9a90@mail.gmail.com>
	 <20090312081113.GA19506@localhost>
	 <e2dc2c680903120117j7be962b2xd63f3296f8f65a46@mail.gmail.com>
	 <20090312103847.GA20210@localhost>
Date: Thu, 12 Mar 2009 12:38:46 +0100
Message-ID: <e2dc2c680903120438i27e209c2h28c61704299b8b4f@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you paste the /proc/meminfo after doing 'echo 3 > drop_caches'?

http://pastebin.com/mce24730

>> I thought the kernel dropped caches if a program needs the ram?
>
> Sure, but something is unreclaimable... Maybe some process is taking a
> lot of shared memory(shm)? What's the output of `lsof`?

I can't paste that, but I expect oracle is using it.

>
>> >
>> > MemTotal:      1034496 kB
>> > MemFree:         95600 kB
>> > Buffers:         49916 kB
>> > Cached:         761544 kB
>> > SwapCached:          0 kB
>> > Active:          80484 kB
>> > Inactive:       749960 kB
>> > HighTotal:      131008 kB
>> > HighFree:        68480 kB
>> > LowTotal:       903488 kB
>> > LowFree:         27120 kB
>> > SwapTotal:     2040212 kB
>> > SwapFree:      2039780 kB
>> > Dirty:               4 kB
>> > Writeback:           0 kB
>> > Mapped:          32636 kB
>> > Slab:            93856 kB
>> > CommitLimit:   2557460 kB
>> > Committed_AS:   129980 kB
>> > PageTables:       1800 kB
>> > VmallocTotal:   106488 kB
>> > VmallocUsed:      3372 kB
>> > VmallocChunk:   102616 kB
>> > HugePages_Total:     0
>> > HugePages_Free:      0
>> > Hugepagesize:     2048 kB
>> >
>> > Is upgrading the kernel an option for you?
>>
>> No :(
>>
>> I think shoving some more ram in the box is the best doable option.
>> Would this help here?
>
> There have been huge amounts of change sets in mm area since 2.6.9...
>
>> To do that I need to say "look at how much cache we are using for
>> files, that cache is in the high mem zone (look here) so let's put
>> some more ram in". Does the cache always live in the high mem zone?
>
> Both highmem and normal zones will be used for caches.
>
> Thanks,
> Fengguang
>
>

Thanks.
