Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0BBW1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:27:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab0BBW1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:27:06 -0500
Message-ID: <4B68A68C.6030001@gmail.com>
Date: Tue, 02 Feb 2010 23:26:20 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Ronni Holm-Nielsen <theronni@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Johannes Buchner <buchner.johannes@gmx.at>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
References: <201002020255.46920.edward.shishkin@gmail.com>	 <20100202081728.GA2384@infradead.org> <4B6843E9.9070600@gmail.com>	 <20100202194208.GD5733@kernel.dk> <5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
In-Reply-To: <5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

The patches 1-3 are reverses for the following -mm stuff:

http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-fixed-null-pointer-dereference.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-vfs-add-super_operationssync_inodes-2.patch

This is incorrect attempts to adjust reiser4 to the new per-bdi flushing 
model.
The authors are cc-ed,
any comments, suggestions are welcome.

Thanks,
Edward.


Ronni Holm-Nielsen wrote:
> To clarify (being a ReiserFS subscriber):
>
> patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel, xfs,
> jens.axboe
> patch 1-3, 7 sent to Andrew, ReiserFS
>
> - Ronni
>
> On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
>   
>> On Tue, Feb 02 2010, Edward Shishkin wrote:
>>     
>>> Christoph Hellwig wrote:
>>>       
>>>> I got this introduction twice, but patches 1-3 didn't make it to any of
>>>> the lists.
>>>>
>>>>
>>>>
>>>>         
>>> done
>>>       
>> Where?
>>
>> --
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>
>
>   

