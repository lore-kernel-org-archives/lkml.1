Return-Path: <linux-kernel-owner+w=401wt.eu-S965923AbXBOMX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965923AbXBOMX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965924AbXBOMX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:23:57 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:53658 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965923AbXBOMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:23:56 -0500
X-Greylist: delayed 1749 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 07:23:55 EST
From: Mws <mws@twisted-brains.org>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Date: Thu, 15 Feb 2007 12:54:38 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
In-Reply-To: <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151254.39058.mws@twisted-brains.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi vj,

On Thursday 15 February 2007, v j wrote:
> This is in reference to the following thread:
> 
> http://lkml.org/lkml/2006/12/14/63
> 
> I am not sure if this is ever addressed in LKML, but linux is _very_
> popular in the embedded space. We (an embedded vendor) chose Linux 3
> years back because of its lack of royalty model, robustness and
> availability of infinite number of open-source tools.
> 
> We recently decided to move to Linux 2.6 for our next product, mainly
> because Linux has worked so well for us in the past, and we would like
> to move up to keep up with the latest and greatest.

you choose to move to linux 2.6 for your next product - fine.
it has worked for you well in the past - fine.
you would like to keep along with the latest and greatest - fine.

_but_

for all those reasons you have to get along with all rules, licenses and
at least all changes that the kernel community decided to perform.

> However in moving to  2.6, we noticed a number of alarming things.
> Porting drivers over from devfs to udev, though easy raised a number
> of alarming issues. Driver's no longer could dynamically allocate
> their MAJOR/MINOR numbers. Doing so would mean they would have to use
> sysfs. However it seems that sysfs (and the class_ interface) is only
> available to GPL modules. This is very concerning. The drivers which
> we have written over the last three years are suddenly under threat.
> We don't mind statically assigning MAJOR/MINOR numbers to our drivers.
> We can do this and modify our user space applications too.
> 
> However we have a worrying trend here. If at some point it becomes
> illegal to load our modules into the linux kernel, then it is
> unacceptable to us. We would have been better off choosing VxWorks or
> OSE 3 years ago when we made an OS choice. The fact that Linux is
> becoming more and more closed is very very alarming.

the trend is not worrying. we are not responsible for your decisions you made 
in the past. 
the only real FACT is that linux is being stated to BE OPEN and what is much more 
important to STAY OPEN for everybody.

you chose it years ago, because of those facts. of course linux is very popular on 
embedded systems. i am working within some open source projects that also run
on embedded hardware designs. 

your main mistake in understanding linux and our way to have it also more open in 
future than by now. 

what actually costs you more in future? 
opening your drivers, as much it must be, to have your hardware supported under 2.6
_or_ 
paying license fees for runtime/development tools for vxworks, ose whatever?

and what will do complain at windriver or other companies, if they decide not to support 
your used cpu architecture anymore?


this were my 0.2$
marcel
 
p.s. you said you like linux for its royalty model - that also includes that you accept all the
      other rules and terms. e.g. gpl license _and_ its fullfillment.

> vj.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


