Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0BVITh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:19:37 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:46532 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0BVITg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KPar7JoQWe1dkMQ0hzF4E/F3sxkAWnp5WCbZ8GyFqHfPH0EswVBwAASOQ7Yznbzr6r
         lobwWnEYpn6Q1z1U0/3BHkzjmuUTR5bWc8BOZwILKTf0G8VE9jCPr7NPJMXqpA5eMB9O
         y4lMiR6PqI6k44sBNtQXlNohTYhSt17H9+cGc=
MIME-Version: 1.0
In-Reply-To: <1266747440.5468.0.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266747440.5468.0.camel@jlt3.sipsolutions.net>
Date: Mon, 22 Feb 2010 16:19:34 +0800
Message-ID: <2375c9f91002220019h32ed0ec3i9d5fa4080a2ca335@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 6:17 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2010-02-21 at 17:51 +0800, Américo Wang wrote:
>> On Sat, Feb 20, 2010 at 9:57 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sat, 2010-02-20 at 21:44 +0800, Américo Wang wrote:
>> >
>> >> That message is displayed before shutting down the devices.
>> >>
>> >> To verify, you can add some printk() in the end of
>> >> __cpufreq_remove_dev(), or enable CONFIG_CPU_FREQ_DEBUG.
>> >
>> > That is already enabled.
>> >
>>
>> Ok, I got it.
>>
>> Could you test the patch below? Thanks!
>
> No change, sorry, still hangs right after "Disabling non-boot CPUs ..."
> before the machine turns off.
>

Oh, I see, then this will be another problem.

My previous patch is to fix the cpufreq lockdep warning mentioned
in Benjamin's report, so this hang should be caused by other problem,
not the cpufreq lockdep problem.

Thanks.
