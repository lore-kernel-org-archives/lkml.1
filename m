Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZEKLTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZEKLTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZEKLTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:19:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEKLTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:19:23 -0400
Date: Mon, 11 May 2009 13:19:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] xen: hook io_apic read/write operations
Message-ID: <20090511111904.GK4648@elte.hu>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org> <1241730883-4917-3-git-send-email-jeremy@goop.org> <20090509084201.GF3656@elte.hu> <20090509084324.GA5158@elte.hu> <4A05A408.3020006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A05A408.3020006@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> And on a higher level, i still dont see why you dont do the whole 
>> Xen thing under an irqchip. There should be no extra crappy 
>> checks in native code.
>
> Hm, every time you see this code, you always have this 
> quasi-Pavlovian response.

Yep, my reaction to ugly code is pretty predictable, and 
(hopefully!) repeatable. So calling it Pavlovian is an implicit 
(albeit, i suspect, unintended ;-) compliment.

> You say "use an irqchip".  I say:
>
>    * We already use irqchip
>    * but most of the interesting IO apic accesses (routing) are not
>      done via the irqchip interface
>    * so irqchip doesn't help

I dont see the problem. All APIs within Linux are kept minimalistic 
and are extended on the fly, on an on-demand basis.

> And then you don't reply.  And then you raise it again.
>
> I would *always* prefer to hook into an interface like irqchip 
> rather than gouge into the code, but I really think that irqchip 
> isn't that interface.  If you have a more specific suggestion or 
> proposal I'll happily follow it up, but repeating "you should use 
> an irqchip" isn't getting anywhere.

Well, my main task at this stage is to point out ugly code. I might 
be able to do research for you and come up with a plan for you, but 
that's really a courtesy in general and is not always possible for 
maintainers. You might argue "of all possible solutions this is the 
cleanest" but i havent seen you make that point.

	Ingo
