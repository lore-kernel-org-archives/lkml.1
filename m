Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYIOUtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYIOUtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYIOUt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:49:28 -0400
Received: from nebensachen.de ([195.34.83.29]:56516 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbYIOUt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:49:27 -0400
X-Hashcash: 1:20:080915:fujita.tomonori@lab.ntt.co.jp::VbUFt5711MUMEKEV:000000000000000000000000000000008Mxl
X-Hashcash: 1:20:080915:jens.axboe@oracle.com::KWfPagSaskb6mkt/:00000000000000000000000000000000000000006vtU
X-Hashcash: 1:20:080915:greg@kroah.com::Ih/fBFYXw9yQHtbw:0003xLP
X-Hashcash: 1:20:080915:linux-kernel@vger.kernel.org::cjkOdQyD/0430D0z:0000000000000000000000000000000002kZz
From: Elias Oltmanns <eo@nebensachen.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: Block: Trouble with kobject initialisation for blk_cmd_filter
References: <20080909214602L.fujita.tomonori@lab.ntt.co.jp>
	<20080909131850.GL20055@kernel.dk> <87fxo1xjz0.fsf@denkblock.local>
	<20080916051752H.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 15 Sep 2008 22:49:13 +0200
In-Reply-To: <20080916051752H.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Tue, 16 Sep 2008 05:17:46 +0900")
Message-ID: <87bpypyw1i.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 15 Sep 2008 21:55:15 +0200
> Elias Oltmanns <eo@nebensachen.de> wrote:
>
>> >> Jens, would it be better to just disable the cmdfilter stuff for
>> >> 2.6.27? It's too late for another try to fix this broken stuff, I
>> >> guess.
>> >
>> > Yeah, it's certainly starting to look like it... The amount of changes
>> > to unbreak it are too large to submit now, so lets postpone it until
>> > 2.6.28.
>> 
>> As far as I can make out, nothing has happened yet at this front. I've
>> just verified that reverting the following commits (in that order) seems
>> to be working nicely for me:
>> 
>> 2dc75d3c3b4
>> bb23b431db7
>> a4a778971b9
>> 4beab5c623f
>> 14e507b852e
>> abf54393704
>> 06a452e5b95
>> 2b272d4f795
>> 0b07de85a76
>> 
>> Is that what you had in mind? Will you take care of it?
>
> The following commit should disable the command filter feature:
>
> commit 2dc75d3c3b49c64fd26b4832a7efb75546cb3fc5
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Thu Sep 11 14:20:23 2008 +0200
>
>     block: disable sysfs parts of the disk command filter

Right, so it really is only the sysfs interface of the command filter
that causes problems, is it? Does that also mean that you are not
unhappy with the command filter in linux-next either except for the
sysfs interfae? I didn't realise that, sorry for the noise.

Regards,

Elias
