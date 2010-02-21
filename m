Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0BUUHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 15:07:21 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53434 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0BUUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 15:07:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aOCApUw2enox0oEcItRW24ZvOUydYhFMlkqaRtajshtUgR5RRI9J7DsSsFfQeNSzIQ
         0As0Zxa+m8bEA089XSydZ4H7vLNT0AZOUY4L6oMcRR0Ah1qLBn36LPoJvdEo6KcHoQGC
         hB6+mtnBa3LOAhG1jV5BIq/ftp0OuitXdwvTw=
Message-ID: <4B8197FA.2080402@gmail.com>
Date: Sun, 21 Feb 2010 21:30:50 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Johannes Buchner <buchner.johannes@gmx.at>
CC: Ronni Holm-Nielsen <theronni@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
References: <201002020255.46920.edward.shishkin@gmail.com>	<20100202081728.GA2384@infradead.org>	<4B6843E9.9070600@gmail.com>	<20100202194208.GD5733@kernel.dk>	<5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>	<4B68A68C.6030001@gmail.com> <20100222084753.0a5d613c.buchner.johannes@gmx.at>
In-Reply-To: <20100222084753.0a5d613c.buchner.johannes@gmx.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Everything should work now (at least it works for me).
Please check the latest -mm or reiser4-for-2.6.32 stuff
If no problems then let's close this BZ..

Thanks,
Edward.

Johannes Buchner wrote:
> Hi.
>
> Thank you Edward. The related bug was/is
> http://bugzilla.kernel.org/show_bug.cgi?id=14915
> It'd be great if someone could solve this, as the reiser4 patch is
> not usable in its current state, with or without my illfated attempts
> to fix it.
>
> Kind regards,
> Johannes
>
> On Tue, 02 Feb 2010 23:26:20 +0100
> Edward Shishkin <edward.shishkin@gmail.com> wrote:
>
>   
>> Hello everyone.
>>
>> The patches 1-3 are reverses for the following -mm stuff:
>>
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-fixed-null-pointer-dereference.patch
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-vfs-add-super_operationssync_inodes-2.patch
>>
>> This is incorrect attempts to adjust reiser4 to the new per-bdi
>> flushing model.
>> The authors are cc-ed,
>> any comments, suggestions are welcome.
>>
>> Thanks,
>> Edward.
>>
>>
>> Ronni Holm-Nielsen wrote:
>>     
>>> To clarify (being a ReiserFS subscriber):
>>>
>>> patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel,
>>> xfs, jens.axboe
>>> patch 1-3, 7 sent to Andrew, ReiserFS
>>>
>>> - Ronni
>>>
>>> On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com>
>>> wrote:
>>>
>>>   
>>>       
>>>> On Tue, Feb 02 2010, Edward Shishkin wrote:
>>>>     
>>>>         
>>>>> Christoph Hellwig wrote:
>>>>>       
>>>>>           
>>>>>> I got this introduction twice, but patches 1-3 didn't make it to
>>>>>> any of the lists.
>>>>>>
>>>>>>
>>>>>>
>>>>>>         
>>>>>>             
>>>>> done
>>>>>       
>>>>>           
>>>> Where?
>>>>
>>>> --
>>>> Jens Axboe
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> reiserfs-devel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>     
>>>>         
>>>
>>>   
>>>       
>
>
>   

