Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbXLOLGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbXLOLGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 06:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXLOLGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 06:06:44 -0500
Received: from www.tglx.de ([62.245.132.106]:56102 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbXLOLGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 06:06:43 -0500
Date: Sat, 15 Dec 2007 12:06:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86_64 and AMD with C1E
In-Reply-To: <471FBC09.8050201@redhat.com>
Message-ID: <alpine.LFD.0.99999.0712151156420.6933@localhost.localdomain>
References: <20071001101532.025d652f@localhost> <4718DDB7.7070707@redhat.com> <b70f2f960710241426y40d25647v3f25b275fad5ce76@mail.gmail.com> <471FBC09.8050201@redhat.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

This whole C1E business is a lot of magic trickery in the guts of the
BIOS. I have an X2 box here with an extrem interesting behaviour. C1E
is not advertised at all, but the box freezes with the same symptoms
unless I disable the local apic timer on the kernel command line. I
have no clue how this works internally.

     tglx
