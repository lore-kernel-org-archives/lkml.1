Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0BUKzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:55:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51836 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0BUKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:55:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vtYa6A2vXQakRypHF6cRkJjiY2zAbxEQwpec/0Vwpq7cgRULPqT7P9yWzG4a0VhHwm
         gnXNXwfc+SykFviT4SjeR+rW7Mf/4sqHsfsHTObz4bSfZilPRGBYfPkcRL4OSEe+4ThH
         Lkb8xe8nudkRbhQ+gFHtyc7XZT2wfu9oegZAM=
MIME-Version: 1.0
In-Reply-To: <1266749023.5468.1.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
Date: Sun, 21 Feb 2010 18:55:52 +0800
Message-ID: <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Xiaotian Feng <xtfeng@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 6:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Incidentally, the machine also freezes hard without any output at all if
> I "echo 0 > /sys/.../cpu1/online".

It might be nothing related with cpufreq. I think there's something
wrong during the _cpu_down path.
put more debug printks into _cpu_down(), if we can find kernel is
stuck in which place in _cpu_down, it would be helpful.

>
> johannes
>
