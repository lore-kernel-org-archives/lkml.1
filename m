Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbXHGKR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbXHGKR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbXHGKRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:17:20 -0400
Received: from neon.samage.net ([85.17.153.66]:41669 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826AbXHGKRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:17:19 -0400
Message-ID: <51001.81.207.0.53.1186481828.squirrel@secure.samage.net>
In-Reply-To: <1186466758.2700.2.camel@laptopd505.fenrus.org>
References: <1185827130.26459.16.camel@xtower.fri>
    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
    <46B06815.10200@gmail.com>
    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
    <46B0818F.10204@gmail.com>
    <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
    <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>
    <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
    <F4037195-194E-4265-9653-ED964CBA41E0@mac.com>
    <1186466758.2700.2.camel@laptopd505.fenrus.org>
Date: Tue, 7 Aug 2007 12:17:08 +0200 (CEST)
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "Indan Zupancic" <indan@nul.nu>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Rene Herman" <rene.herman@gmail.com>, teresa@kvitka.net,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: dfea3049d3b923820beb462d65569822
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, August 7, 2007 08:05, Arjan van de Ven wrote:
> On Tue, 2007-08-07 at 00:40 -0400, Kyle Moffett wrote:
>> On Aug 01, 2007, at 11:06:00, Indan Zupancic wrote:
>> > Different programs, different keys "stuck", so hard to tell. The
>> > amount the pressed key is repeated differs too, from double to
>> > hundreds.
>> >
>> > As an apparently separate problem my mouse warps once in a while
>> > too, and that's not totally fixed yet, neither with that locking
>> > patch. Throw in that two of my USB ports stopped working after a
>> > rare power outage, I didn't totally trust my hardware any more,
>> > hence my initial reluctance to report these problems.
>> >
>> > We could have independent problems with more or less the same
>> > symptoms, at least Teresa's problem seems much worse than ours, and
>> > if you and Ingo only experience a stuck delete key, it might be
>> > something else.
>
>
> the last time I saw something like this it was a BIOS that kept doing
> USB->PS/2 emulation even when the kernel was running.. that caused great
> havoc somehow...
>
> those who are seeing this... is it all on a USB keyboard? If so, is the
> bios set to do PS/2 emulation (sometimes called USB legacy emulation) ??

No, using PS/2 keyboard and mouse here, and made sure to disable USB
legacy emulation in the BIOS ages ago.

But for me the problems are gone now, since 2.6.23-rc1 (I don't think it was
fixed by CFS though, just in the same timeframe).

Greetings,

Indan


