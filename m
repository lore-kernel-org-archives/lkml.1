Return-Path: <linux-kernel-owner+w=401wt.eu-S966097AbXJTB5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966097AbXJTB5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXJTB5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:57:37 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:38910 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751497AbXJTB5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:57:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=KIxg660iZTUEWjWCsfc80c5S6SlqDXCUKSBsGYz5LZEO6bQ7yS4gGQWLo2aInLB2SqbgwDmDClAgqJgjN4R1GLPtGsq+4BVActT2188rDkamQIYHl4iluxFX8J8J3T0GCbdXRCxe1lfX07oJkTWJq5OG6YBTsC4O2iRgS1QirHM=  ;
X-YMail-OSG: oeSaCA0VM1nNqh3LCzDqv.YwDYNdHJJQN.ZgVAxMiTE9j1WS6qzkpdXiBgKL_dkt27TVRqLtXA--
Date: Fri, 19 Oct 2007 18:57:35 -0700
From: David Brownell <david-b@pacbell.net>
To: randy.dunlap@oracle.com
Subject: Re: 2.6.23-git Kconfig regression
Cc: linux-kernel@vger.kernel.org
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071019184607.06e1eef9.randy.dunlap@oracle.com>
In-Reply-To: <20071019184607.06e1eef9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	(Originally posted to kbuild-devel per MAINTAINERS, but
> > 	that post was rejected since that is -- undocumented,
> > 	sigh -- a members-only list.)
>
> That mailing list is no longer used.  Today's git pull for kbuild
> included this change:
>
>  KCONFIG
>  P:	Roman Zippel
>  M:	zippel@linux-m68k.org
> -L:	kbuild-devel@lists.sourceforge.net
> +L:	linux-kbuild@vger.kernel.org
>  S:	Maintained

I hadn't pulled that one yet... ;)


> > I noticed a regression, visible in the drivers/usb/gadget Kconfig;
> > it seems to be quite recent.
> > 
> > ...
>
> Hm, it does look very odd.  It looks like it has something to
> do with <choice> working differently for some reason.
>
> In xconfig, I set all of the View Options and when I click on one
> of the periph. controllers, it says
>
> 	depends on =y && PCI

That's what I saw too.  Looked dubious ... 


> but if I back up to -git7, it says
>
> 	depends on <choice> && PCI

And that git7 thing doesn't look _quite_ so odd.  Did git7 actually
let you configure a modular GOKU (for example), i.e. work correctly?


> I'll keep looking.

Thanks.  Kconfig is one of the areas I prefer to let others
be the experts.  :)

- Dave

