Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbXFQO3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbXFQO3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbXFQO3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:29:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37503 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757373AbXFQO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:29:36 -0400
Date: Sun, 17 Jun 2007 16:29:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: How to improve the quality of the kernel?
Message-ID: <20070617142950.GW3588@stusta.de>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de> <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 03:17:58PM +0200, Michal Piotrowski wrote:
> On 17/06/07, Adrian Bunk <bunk@stusta.de> wrote:
>...
>> Fine with me, but:
>>
>> There are not so simple cases like big infrastructure patches with
>> 20 other patches in the tree depending on it causing a regression, or
>> even worse, a big infrastructure patch exposing a latent old bug in some
>> completely different area of the kernel.
>
> It is different case.
>
> "If the patch introduces a new regression"
>
> introduces != exposes an old bug

My remark was meant as a note "this sentence can't handle all 
regressions" (and for a user it doesn't matter whether a new 
regression is introduced or an old regression exposed).

It could be we simply agree on this one.  ;-)

> Removal of 20 patches will be painful, but sometimes you need to
> "choose minor evil to prevent a greater one" [1].
> 
>> And we should be aware that reverting is only a workaround for the real
>> problem which lies in our bug handling.
>...

And this is something I want to emphasize again.

How can we make any progress with the real problem and not only the 
symptoms?

There's now much money in the Linux market, and the kernel quality 
problems might result in real costs in the support of companies like
IBM, SGI, Redhat or Novell (plus it harms the Linux image which might 
result in lower revenues).

If [1] this is true, it might even pay pay off for them to each assign 
X man hours per month of experienced kernel developers to upstream 
kernel bug handling?

This is just a wild thought and it might be nonsense - better 
suggestions for solving our quality problems would be highly welcome...

cu
Adrian

[1] note that this is an "if"

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

