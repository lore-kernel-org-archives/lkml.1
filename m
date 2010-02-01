Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0BACyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 21:54:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:39889 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0BACyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 21:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EqWvXU78aaP+Ib4Bh5C7e5tL/8P0j/H/+FYs/rmbL9vb+NmhHVBdFjfgk+dw0FU2kd
         3vGmssyCVeab25LtE2PorUeLPB0sSBGQ42V4e1qTagV1RilTyPz1TWk+xq6ZDQLSEnTi
         H1xbc9yxbcJyJHp35gLU0twTQpDMiiB26qXeI=
MIME-Version: 1.0
In-Reply-To: <20100131183807.309a902f.akpm@linux-foundation.org>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
	 <b6fcc0a1001310406j3924731du4727bd82cb23ea9a@mail.gmail.com>
	 <20100131183807.309a902f.akpm@linux-foundation.org>
Date: Mon, 1 Feb 2010 11:54:14 +0900
Message-ID: <961aa3351001311854s40d33804m715d7643fe430b5b@mail.gmail.com>
Subject: Re: [PATCH 1/7] sched: Use for_each_bit
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/1 Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 31 Jan 2010 14:06:10 +0200 Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On Sun, Jan 31, 2010 at 1:53 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>> > __#define for_each_cpupri_active(array, idx) __ __ __ __ __ __ __ __ __ __\
>> > - __for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES); __ __ \
>> > - __ __ __ idx < CPUPRI_NR_PRIORITIES; __ __ __ __ __ __ __ __ __ __ __ __ __ __\
>> > - __ __ __ idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
>> > + __ __ __ for_each_bit(idx, array, CPUPRI_NR_PRIORITIES)
>>
>> It should be called for_each_set_bit().
>
> Agree.

(I'm resending because I failed to reply all)

You mean for_each_bit() should be renamed to for_each_set_bit() ?

I'm not sure. But if so, find_first_bit() also should be renamed to
find_first_set_bit() and so on?
