Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0BVIXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:23:01 -0500
Received: from mail-qy0-f175.google.com ([209.85.221.175]:50187 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0BVIW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:22:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DGix/WclHuzj/o70zXSunne8yaoHxLaEUbgZ8o7Uxh37u6Sv03uWMM74XLyl/jL/OV
         OE+rO8mWOc23r8Bh8qpaP8GTVtqeoWWYw2ZJvl91sb0GXzGl1hQrb7cL345G0thq3aiE
         zrEzumGaDV4HVXnzqrm4909KQorhog/3VbRBg=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
Date: Mon, 22 Feb 2010 16:22:58 +0800
Message-ID: <2375c9f91002220022r63d209d0w2c0137bc1c2d2ec1@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 7:12 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Sun, Feb 21, 2010 at 6:55 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>> On Sun, Feb 21, 2010 at 6:43 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> Incidentally, the machine also freezes hard without any output at all if
>>> I "echo 0 > /sys/.../cpu1/online".
>>
>> It might be nothing related with cpufreq. I think there's something
>> wrong during the _cpu_down path.
>> put more debug printks into _cpu_down(), if we can find kernel is
>> stuck in which place in _cpu_down, it would be helpful.
>
> and it looks like this breakage is only seen on powerMac G5, so it
> might be arch specific. Maybe some commit in powermac breaks G5's
> cpu_down, just a guess ;-)
>

Maybe not, there could be some generic code bug that will only be
exposed on a specific arch.

Thanks.
