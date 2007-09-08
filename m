Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbXIHASq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbXIHASq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 20:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXIHASj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 20:18:39 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:21591 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750791AbXIHASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 20:18:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=M+DheW33iNq5soog1cABLNO5iIRAkNWDutgCYDvkle5hgWp2d1DOqhXDTtNEf5Fk4z3nC1Xl175kquZn6h81RJOuOf6onoG48fQd4Tbvn9rybcmSi6FMVlJtuz5zBRm00hKzcVqd+txmpKUNlUXpmEgOgl2R88mgfiiKXE9icyA=  ;
X-YMail-OSG: eS2WZKQVM1lvH34YFCBMiBaYYwMvLjFzGpBhArpNSDRXKHby7gp0BP2Xn0HUy2fI3ec1txiomA--
Date: Fri, 07 Sep 2007 17:18:35 -0700
From: David Brownell <david-b@pacbell.net>
To: hmh@hmh.eng.br
Subject: Re: Platform device id
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, gregkh@suse.de,
       dmitry.torokhov@gmail.com
References: <20070907153559.17faf9d1@hyperion.delvare>
 <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
 <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20070907210029.GB4357@khazad-dum.debian.net>
 <20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20070907220407.GE4357@khazad-dum.debian.net>
In-Reply-To: <20070907220407.GE4357@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070908001835.C7F721B729B@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > (Also, note that "platform", "host", and "board" are ambiguous.
> > In some contexts each is synonymous; in others, not.  I avoid
>
> In this specific case I am talking about, they're not.

That is, in *YOUR* usage context they're not.  I had to parse
what you wrote a few times before your comments about $SUBJECT
started to make sense.  I've *never* heard "host" used that way,
and rarely hear "platform" used that way either.


> The platform for a ThinkPad is either i386 or amd64.

Both i386 and x86_64 are clearly an "arch".  They even live in
an "arch" directory:  linux/arch/{i386,x86_64}.

When folk talk about a "PC Platform", they're talking about a
thing that doesn't quite exist in today's Linux tree.  If we
ever get to an arch/x86, that could have a plat-pc (or mach-pc)
subdirectory.  ThinkPads should then be a variant of that.


> I don't feel like drivers like hdaps, thinkpad-acpi, dock, bay,
> and many others really belong in the platform bus.  But that's
> what happens right now.

As a rule, there needs to be a Good Reason to create a new bus
type.  A "feel" is a pretty weak reason...

- Dave

