Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXJXWNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXJXWNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXJXWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:13:00 -0400
Received: from www.tglx.de ([62.245.132.106]:39873 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbXJXWM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:12:59 -0400
Date: Thu, 25 Oct 2007 00:12:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86_64 and AMD with C1E
In-Reply-To: <471FBC09.8050201@redhat.com>
Message-ID: <alpine.LFD.0.9999.0710250007230.3186@localhost.localdomain>
References: <20071001101532.025d652f@localhost> <4718DDB7.7070707@redhat.com> <b70f2f960710241426y40d25647v3f25b275fad5ce76@mail.gmail.com> <471FBC09.8050201@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Chuck Ebbert wrote:
> On 10/24/2007 05:26 PM, Mikhail Kshevetskiy wrote:
> >>>
> >>> I fill something wrong here.
> >>> Is it possible to reduce the amount of timer interrupts?
> >>> Is it possible to force enable C1,C2 and C3 states when c1e disabled?
> >>>
> >> How are you disabling C1E?
> >>
> >>
> > dirty hack, i just follow the FreeBSD way and clear C1e bit in lapic
> > initialization code. I make it for test purpose only, so i do not produce a
> > patch.
> > 
> 
> Why does disabling C1E disable C1, C2 and C3?
> 
> Thomas, in the case of the machines where C1E is disabled on CPU 0 but
> enabled on CPU 1, could we just disable it? Maybe it's a BIOS bug and the
> vendor just forgot to disable CPU 1...

It's definitely a BIOS bug and I doubt that disabling the bit works on
every BIOS. I have a system here on my desk, where neither of the CPUs
has the bit set, but the lapic timer stops wreckage is there once both
CPUs go into idle. 

The mindless creativity of BIOS writers seems to exceed the ability of
hardware designers to produce strange chips by orders of magnitude.

   tglx

