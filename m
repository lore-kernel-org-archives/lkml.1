Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYIHTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYIHTDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYIHTDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:03:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45237 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbYIHTDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:03:04 -0400
Date: Mon, 8 Sep 2008 21:02:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080908190249.GA21998@elte.hu>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C57439.3040903@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Arjan van de Ven wrote:
>>
>> the ideal case would be "support them all"
>
> Not really.  That would include things like the i386, which is a bunch 
> of really nasty stuff.

agreed - especially the verify_area() impact makes it a non-starter.

but 486 and higher is certainly quite reasonable, and is still being 
tested.

... and _in practice_ 99% of all systems that run Linux today understand 
CMOV.

... _and_ in practice 99% of all new Linux systems shipped today are 
Core2 or better.

... and so on it goes with this argument. Everyone has a different 
target audience and there's no firm limit. Maybe what makes more sense 
is to have some sort of time dependency:

  support all x86 CPUs released in the last year
  support all x86 CPUs released in the past 5 years
  support all x86 CPUs released in the past 10 years
  support all x86 CPUs released ever
  [ ... or configure a specific model ]

and people/distributions would use _those_ switches. That means we could 
continuously tweak those targets, as systems become obsolete and new 
CPUs arrive.

	Ingo
