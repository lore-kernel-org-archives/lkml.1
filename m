Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYBJGS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYBJGS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYBJGSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:18:17 -0500
Received: from keil-draco.com ([216.193.185.50]:50932 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYBJGSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:18:16 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Sun, 10 Feb 2008 01:18:05 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: davids@webmaster.com, David Newall <davidn@davidnewall.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com> <200802100007.50441.dhazelton@enter.net> <1202622229.7664.65.camel@violet>
In-Reply-To: <1202622229.7664.65.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802100118.05875.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008 00:43:49 Marcel Holtmann wrote:
> Hi Daniel,
>
> > > > > It makes no difference if you
> > > > > distribute the GPL library with it or not.
> > > >
> > > > If you do not distribute the GPL library, the library is simply being
> > > > used in the intended, ordinary way. You do not need to agree to, nor
> > > > can you violate, the GPL simply by using a work in its ordinary
> > > > intended way.
> > > >
> > > > If the application contains insufficient copyrightable expression
> > > > from the library to be considered a derivative work (and purely
> > > > functional things do not count), then it cannot be a derivative work.
> > > > The library is not being copied or distributed. So how can its
> > > > copyright be infringed?
> > >
> > > go ahead and create an application that uses a GPL only library. Then
> > > ask a lawyer if it is okay to distribute your application in binary
> > > only form without making the source code available (according to the
> > > GPL).
> > >
> > > http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#IfLibraryIsGP
> > >L
> > >
> > > http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#LinkingWithGP
> > >L
> >
> > In the US, at least, the belief that "Linking", in *ANY* form, with a GPL
> > library creates a derivative work, is fallacious.
>
> that is how FSF states it and it seems that most legal departments of
> big companies (US and EU based) are not taking any risk on this. So it
> seems that someone actually has to prove in court that these assumptions
> for the GPL case are wrong.

The FSF is making a claim that can be traced back to the beliefs of one 
person - RMS - and that propagate their views. As I stated in the original, 
this is not just my opinion, but that of two different lawyers I've spoken to 
and also the stated belief of numerous people on LKML. 

The fact is that the GPL only affects a "derivative work" in a viral manner. 
Merely using a GPL'd libraries API is not enough to make a program 
a "derivative work". 

> > Were I to create an
> > application that uses, say, GTK for the interface the protected
> > expression is my "unique and creative" use of the GTK API for creating
> > the specific interface and any other code I have written using the API. I
> > hold sole license to the copyright on that code and am able to license
> > said code under the specific license of my choice.
>
> Not even getting into this one since GTK+ is a LGPL based library. Get
> your examples straight.

And the LGPL was created because of the FSF propagated belief that using a 
GPL'd library means your application is automatically a "derivative work" and 
hence must be released under the GPL. So the LGPL was created with 
the "automatic" 'linking' exemption. It is not necessary and never has been.

This is why, even if the FSF claims what I've said above (that linking code 
with the GPL doesn't propagate the GPL into the non-GPL code) most companies 
won't risk it... Because the FSF has taken actions that are the exact 
opposite of their words.

> > Why? Because the pre-processor is what is including any GPL'd code in my
> > application and expanding any macros. That is a purely mechanical process
> > and hence the output is not able to be separately copyrighted - if it
> > could be, then the copyright would be held by the *COMPILER*, and I am
> > *NOT* bound by the license on that code. The same applies if GPL'd code
> > is included in my application during the linking process. QED: The
> > "Linking" argument used by most people is wholly fallacious in at least
> > one major country - and if I'm not mistaken, the output from an automated
> > process is similarly not considered as carrying a separate copyright in
> > all nations that are signatories of or follow the Bern Convention.
>
> The GPL is a license. Nobody is talking about the copyright of your code
> here. You always have the copyright on your code. The point is that you
> have to license your code under GPL (when using a GPL library) and you
> are distributing your code.

Yes, It is "my" code and "my" copyright. However, by the absolutely *common* 
belief that "linking to GPL libraries makes a program a derivative work" it 
would mean that I no longer have the freedom to license my code under the 
license of my choosing, because the *mechanical* process of linking has 
caused the GPL's "viral" clause to spread to cover my code.

And you're absolutely wrong. It doesn't matter that the library is GPL'd at 
all. My code *cannot*, under any circumstances, be affected by the GPL 
license on the library. Because the libraries API *cannot* be copyrighted and 
any GPL'd code which winds up in the final binary got there via a "mechanical 
process" and doesn't affect my right to release the code under a license of 
my choosing.

Any other belief is fallacious. Claiming otherwise would mean that any program 
that uses any library on a windows system makes an application a derivative 
work of that library.

DRH
PS: I'm going to shut up again, because I've been party in my fill of these 
copyright/derivative work discussions (on both sides) and have had the 
problems with the "FSF Line" repeatedly pointed out to me.

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
