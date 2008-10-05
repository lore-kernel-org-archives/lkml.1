Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYJESGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYJESGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYJESGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:06:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:43900 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbYJESGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ijc4efnEWh1MG5fwMKt/nL/3gy8s53WpRf4QX0LQ+5C2+N02RrpwlPw9FQqqcIEsSD
         NflyFTY1WpEMyOos/BKJR1iGVfcCTcPCa/RtfrZbM1s7NVNBNbH4liYQvgak0pECRcQR
         Qa9kdWze94QgiSh7hFUEUPxqC9q1+BwKgR8xg=
Message-ID: <86802c440810051106l6d58076cnb4a29ddd282e4ac@mail.gmail.com>
Date: Sun, 5 Oct 2008 11:06:32 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: drivers/pci/probe.c compile warnings on -tip
Cc: "Steven Noonan" <steven@uplinklabs.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <20081005101801.GI29909@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0810010102y551f4a3bs64524fa70ef04ca3@mail.gmail.com>
	 <18659.21853.41967.715062@harpo.it.uu.se>
	 <200810010851.15969.jbarnes@virtuousgeek.org>
	 <f488382f0810042055o68778028t1bb0754126d6bb0@mail.gmail.com>
	 <20081005101801.GI29909@elte.hu>
X-Google-Sender-Auth: 468e839045f4235f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2008 at 3:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steven Noonan <steven@uplinklabs.net> wrote:
>
>> > AFAICT, these are fixed in Linus' tree, maybe the x86 tree needs an
>> > update?
>> >
>>
>> Hey Ingo, these warnings are still showing up on the latest -tip. Any
>> idea why?
>
> yes, they got reintroduced via:
>
> | From ca81beb4a340ee690803fcb1498f863d0e68843f Mon Sep 17 00:00:00 2001
> | From: Yinghai Lu <yhlu.kernel@gmail.com>
> | Date: Thu, 4 Sep 2008 20:57:15 +0200
> | Subject: [PATCH] pci: fix BAR print out
>
> which spread into a few topic branches:
>
> # irq/sparseirq: ca81beb: pci: fix BAR print out
> # irq/sparseirq: f430d990: Merge branch 'linus' into irq/sparseirq
> # timers/hpet-percpu: ca81beb: pci: fix BAR print out
> # x86/uv: ca81beb: pci: fix BAR print out
> # x86/uv: f430d990: Merge branch 'linus' into irq/sparseirq
>
> i suspect f430d990 is where the in-linus fix collided with the
> in-irq/sparseirq fix. I'm inclined to revert it. Yinghai?
>

please. it should be reverted from irq/sparseirq etc branch...because
updated one is already in linus tree.

YH
