Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXFOSRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXFOSRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXFOSRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:17:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbXFOSQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:16:59 -0400
Date: Fri, 15 Jun 2007 11:15:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Daniel Hazelton <dhazelton@enter.net>, Bernd Paysan <bernd.paysan@gmx.de>,
       Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070615164347.GA4952@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706151101020.14121@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
 <20070615052432.GC14911@thunk.org> <200706151202.13708.bernd.paysan@gmx.de>
 <200706150633.51857.dhazelton@enter.net> <20070615130254.GB11830@alinoe.com>
 <alpine.LFD.0.98.0706150830020.14121@woody.linux-foundation.org>
 <20070615164347.GA4952@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Carlo Wood wrote:
> 
> The point is: can you, or can't you (legally) relicense the whole kernel
> tree under the GPLv3 (or GPLv2+GPLv3)?

No. My special rights do not actually give me those kinds of powers, 
exactly because I'm bound by my _other_ agreement (namely the GPLv2) to 
follow the license of the code that other people have sent me.

> At first I thought that you cannot, because too many (significant) contributors
> have been involved (and you will never get signatures from them all).
> Then someone surprised me by claiming that the original author had
> copyright for everything - even files added by others.

Both are true facts, but the "copyright for everything" is a *separate* 
kind of copyright, which does not include the right to relicense. It's 
literally the "copyright in the collective".

For examples of the US rules, see USC 17.2.201(c) ("Ownership of 
copyright" and " Contributions to Collective Works"), which spells out 
some limited special rights that I have (namely the right to reproduce and 
distribute).

Of course, US law being what it is, the USC is just part of the picture. 
US law is the strange kind of British law, where "case law" is in many 
ways more important than the written-down rules like the USC. So caveat 
emptor!

So I have limited special rights in the collective, but those rights are 
actually in almost every way *more* limited than the rights that the GPLv2 
gives to me (the "almost every way" is because quite frankly, I'm not 
entirely sure about certain special cases. In particular, if somebody 
tried to _revoke_ the rights to their code under the GPLv2, I suspect that 
my rights in the collective would protect me from that and allow me to 
still distribute the code in question, since _those_ rights cannot be 
revoked, and they are _mine_).

And btw: the above paragraph is *way* more legalistic detail than I am at 
all ready to state as "fact". It depends on too many things, and is 
largely speculative in nature.

But one thing is pretty clear and nonspeculative: *nobody* has the right 
to upgrade the kernel to GPLv3. Not me, not you, not anybody. Not without 
clearing it with every single person whose copyright is involved and who 
didn't already give that permission.

So only in the case of some really obscure and unclear situations, I _may_ 
have more rights than some other people, but trust me, but that is damn 
murky, and you'd better have a good lawyer state it, not just a programmer 
who has talked to too many lawyers..

			Linus
