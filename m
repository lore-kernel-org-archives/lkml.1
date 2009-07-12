Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZGLIxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZGLIxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbZGLIwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:52:51 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:46902 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZGLIwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:52:49 -0400
Message-ID: <4A59A45D.4030407@davidnewall.com>
Date: Sun, 12 Jul 2009 18:22:45 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907100023.48039.Martin@lichtvoll.de> <4A569D36.3060707@davidnewall.com> (sfid-20090710_091245_389167_A9F855BE) <200907102049.12427.Martin@lichtvoll.de>
In-Reply-To: <200907102049.12427.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> The FAT patents have not yet been tested. 
> They might easily just be void and invalid.
>   

It might be invalid, but it would take a lot of money to get just the US
Patent invalidated.  Since it's probably also patented in Australia, UK,
Japan, Germany and so on, you'd need to invalidate it there, too, to
wipe out the problem, and a US decision to revoke wouldn't help much.

Don't worry about whether the patent is valid, because we can't fight
that.  Tom Tom chose not to fight the patent, which let's you know how
big we could be and still be unable to fight it.  Instead, think of ways
to side-step it.



> But going the way you outline would be giving in to the patent claim 
> *before* it has even been tried and tested for validity. And thus IMHO 
> this strengthens the patent and it holder. If you change the upstream 
> kernel Microsoft can always say: "Look Linux kernel developers think that 
> the kernel infringed our patents." 
>   

Working around a patent in no way strengthens the patent claims.  Even
if it did, if we come up with an alternative that gives long and short
file names without going through the steps that Microsoft described in
their patent, then we wouldn't be violating their patent.  Remember
this: Microsoft did not patent a file system with long and short file
names.  I understand that is not even a patentable matter.  Microsoft
patented a *method* for creating long and short files, and if we don't
follow their method then their patent doesn't cover what we do.

Let's find a solution that Microsoft haven't patented, and then give
that to the world.  While it might still look like a duck, walk like a
duck and quack like a duck, we need only put the feathers on *before*
the feet, and then it isn't a duck under patent law.


>> I think you're right that Microsoft does not want their patent tested
>> in court, but as they have more money than anyone, they could keep a
>> patent case in court forever, costing both them and those they sue more
>> and more money.  If the other party keeps fighting they stand a real
>> chance of running out of money (and thus out of business); or they
>> could settle, as Tom Tom did.
>>     
>
> I think you omit that doing this would cost Microsoft really lots of 
> reputation. I believe that Microsoft fears testing the patent in trial and 
> having a long trial just as much if not more than the company it sues.
>   

You think Microsoft fear testing in court, yet we know otherwise because
they already did initiate action against Tom Tom.  Think what you like,
but I will stick, unimaginative thought it might be, to the real world.

> Would you buy a Unix or something else from SCO?
Let me put it this way: going back only a few years, we had no choice
over who provided local calls.  Even though almost everybody agreed they
were expensive, unfriendly and disinterested in their customers' needs,
we still bought from them.


One thing I suspect none of us would deny is that the patent system is
seriously flawed.  Sadly, that's completely irrelevant.  It's long been
accepted that the Law is an ass, but it's still the law and if you
disobey it it will slap you so hard and quickly your head will spin.
