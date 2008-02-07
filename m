Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbYBGRuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbYBGRuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYBGRuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:50:07 -0500
Received: from www.tglx.de ([62.245.132.106]:52335 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbYBGRuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:50:05 -0500
Date: Thu, 7 Feb 2008 18:49:39 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: David Newall <davidn@davidnewall.com>
Cc: Christer Weinigel <christer@weinigel.se>,
       Marcel Holtmann <marcel@holtmann.org>,
       Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080207184939.17030887@dilbert.local>
In-Reply-To: <47AB36D2.5050602@davidnewall.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<47A764ED.8030605@weinigel.se>
	<1202161091.15090.84.camel@violet>
	<20080206213449.6614efea@weinigel.se>
	<20080206215442.63c94cf3@dilbert.local>
	<47AB056E.70802@davidnewall.com>
	<20080207150612.21ba60df@dilbert.local>
	<47AB163C.5070107@davidnewall.com>
	<20080207171322.40eb7c95@dilbert.local>
	<47AB36D2.5050602@davidnewall.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 08 Feb 2008 03:20:26 +1030
schrieb David Newall <davidn@davidnewall.com>:

> Hans-Jürgen Koch wrote:
> > Am Fri, 08 Feb 2008 01:01:24 +1030
> > schrieb David Newall <davidn@davidnewall.com>:
> >   
> >>> It is not legally meaningless if copyright holders publicly state
> >>> how they interpret the license and what they consider a license
> >>> violation. 
> >>>       
> >> Copyright-holders' opinions mean nothing.  In the particular case
> >> of EXPORT_SYMBOL_GPL, copyright-holders' opinions are clearly
> >> flawed because they make a statement about code that they do not
> >> even know of. 
> >>     
> >
> > What are you talking about? That's what every GPL-licensed library
> > does. By putting a library under the GPL, the copyright-holder
> > clearly states that he considers all programs that link against
> > that library a derived work. And that he therefor requires these
> > programs to be GPL, too, no matter if these programs already exist
> > or not. 
> 
> Your last sentence, above: That is what EXPORT_SYMBOL_GPL attempts to
> do.  The place to state such a requirement is in the licence, not in
> the source code.  That is what I am talking about.  I can't provide
> you with software under a licence that says, "you are free to use
> this software in any way you want," and later say, "oh, but in the
> source code is tells you that you must take a break every two hours
> of use."

The license says that derivative work has to be GPL. Naturally, every
sensible and practically usable license has gray areas. We know that
and we live with that. But if there's room for interpretation, it's
perfectly OK and helpful, if the copyright holder states what his
interpretation is. If you use an EXPORT_SYMBOL_GPL symbol in non-GPL
code, you know that the owner of the work doesn't agree with you
license-wise. You had to cheat, e.g. by setting your MODULE_LICENCE to
"GPL", and deliberately acted against the wishes of the copyright
holder. Here in Germany, the GPL is enforceable, and such evidence
will at least weaken your position. You won't get away with just
saying you didn't know the copyright holder's position. Even
printouts of some mails in this thread could be used to prove that
you knew.   
IANAL, there hasn't been such a case AFAIK, and you might well leave
the court unharmed. But can you (or anyone else) be sure? That's what
it's all about.

> 
> 
> >> Less there be further confusion: I am not an advocate for binary
> >> drivers.  
> >>     
> >
> > Nice to hear. So, if you're an advocate for open source drivers,
> > why do you have problems making them GPL?
> >   
> 
> I don't, but EXPORT_SYMBOL_GPL doesn't do that.  It makes an ambit
> claim, that might coerce an author into making a driver GPL, but might
> also cause them to exit the Linux market.  I have a problem with
> driving manufacturers away from Linux.
> 
> > Using a symbol from a library means linking to it, and that creates
> > a derived work. Why should it be different when using kernel
> > symbols?
> I don't agree with your claim, but I'm going to explain something
> else: The GPL doesn't require software that *uses* GPL code to itself
> be GPL. 

Yes it does. Chapter 2b requires any part that is derived from a GPL
work to be GPL, too. As you well know.
Just to help you a bit: The only argument you could use is that a
kernel module, even if it uses GPL'ed kernel code, is not a derivative work.
You _might_ succeed with that interpretation, even before a German
court, and even if it can be proven that you knew that the original
author doesn't agree with you. Come on, try it!

> It requires software that is *distributed* as part of a GPL
> work to itself be GPL.  At time of distribution, a kernel module is
> neither using nor linked to the kernel.

Oh, come on! You cannot turn a derived work into an original work just
by distributing them seperately.

Thanks,
Hans

