Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXEZTPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXEZTPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXEZTO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:14:57 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40525
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXEZTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:14:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 21:14:48 +0200
User-Agent: KMail/1.9.6
Cc: "Benoit Boissinot" <bboissin@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <40f323d00705261141m7c32d2b8h7059b4b35ed066c9@mail.gmail.com> <200705262058.37454.uwe.bugla@gmx.de>
In-Reply-To: <200705262058.37454.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262114.48825.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 20:58:37 Uwe Bugla wrote:
> Am Samstag, 26. Mai 2007 20:41 schrieben Sie:
> > On 5/26/07, Michael Buesch <mb@bu3sch.de> wrote:
> > > On Saturday 26 May 2007 19:04:04 Uwe Bugla wrote:
> > > > Yes, sure! But the help text is very unlucky and humble, and it is not
> > > > clear enough in the sense of being distinctive enough, just clear and
> > > > comprehensive.
> > >
> > > Why don't you simply submit a patch to change the helptext then?
> >
> > Is that ok ?
> >
> > Discourage people from deselecting B44_PCI
> >
> > Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> >
> > --- kernel.orig/drivers/net/Kconfig	2007-05-26 20:38:02.000000000 +0200
> > +++ kernel/drivers/net/Kconfig	2007-05-26 20:38:15.000000000 +0200
> > @@ -1449,7 +1449,7 @@
> >  	help
> >  	  Support for b44 PCI devices.
> >
> > -	  Say Y
> > +	  Unless you know what you are doing, say Y here.
> >
> >  config FORCEDETH
> >  	tristate "nForce Ethernet support"
> 
> No, That is NOT OK! That's nothing but a joke, and if it is a joke : )
> it hits well in Mister Buesches direction. In so far it's 
> well-done : ) : ) : )

See what I meant, Benoit?

> To be honest:
> 
> I expect at least TWO explained cases:
> 
> A. The case in which the b44 module is a PCI module (onboard, additional PCI 
> card etc.).
> 
> B. At least one well described case in which the b44 module is a bus 
> independent one.

You still didn't get it, right?
b44-ssb is a SSB device driver. No PCI, nothing. To get this working
on PCI you need to enable the PCI glue. Which is enabled by default.
It even includes the comment "Say Y". If you say N nevertheless it's
your fault.
What's so hard to understand about this? We have LOTS of drivers in the
kernel that work _exactly_ the same way. There is a base module to drive
the hardware and several glue drivers. If you de-select the glue driver
it doesn't work.
If you use your old config and do not DISABLE some option you will
not experience a regression (at least regarding to the kconfig stuff.
There's still your transmission bug left).

> Apart from that, it is Michael's task to explain the what and why, not mine 
> and not yours! It is him that wants his stuff being pulled into mainline, and 

My task is _nothing_. This is opensource. If you don't like
something about it, go and fix it. But don't say it's the _task_ of others
to fix things you don't like. I am not payed to do this for you.
Though, I'd like to resolve it.

> in so far he very well can do the "dirty work" of documentation, explanation.

I explained it several times now. I'm not sure what else I should
say about it.

-- 
Greetings Michael.
