Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbXKJIGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbXKJIGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXKJIGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:06:16 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:48593 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751007AbXKJIGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:06:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=auFY+1VsBqPwjAQlaEph7DlCZvuYkr957HJkbUIvuV4D0VdISMi122kvrOdsIWNaRszrM0Zl99BS1xEv7AfY9++xCQb7oop+EJvTkk4iqhqVJNGkWpN9Md/4oIRFK0G4QcIgpa3LhaP01fvz5kpe43zXyHBaVyyabHiFvPq4VLg=  ;
X-YMail-OSG: BPCBjO4VM1kUulWH8cfBA3wKp5PrcpZxFrmCfOvsMyKH9SO2BQ6y8MW1hOHqkN83vcXPtoqhWg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Date: Sat, 10 Nov 2007 16:26:30 +1100
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org>
In-Reply-To: <20071110075444.GA5707@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101626.31500.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 November 2007 18:54, Sam Ravnborg wrote:
> On Fri, Nov 09, 2007 at 10:23:23PM -0500, Jeff Garzik wrote:
> > Sam Ravnborg wrote:
> > >This is the patch that get rid of ARCH=i386 and ARCH=x86_64
> > >and introduce ARCH=x86.
> > >It touches several files but the changes are all one or two-liners.
> > >
> > >      x86: drop backward compatibility symlinks to i386/boot and
> > >      x86_64/boot
> > >      kbuild: sanity check the specified arch
> >
> > IMO it negatives impacts the workflow when you -remove- the ability to
> > set 32/64-bit on the make command line.
> >
> > Building and testing for both architectures now requires the additional
> > step of editing .config, which is a clear workflow negative impact at
> > least for me.
>
> When it was decided to unify i386 and x86_64 it was at the same time
> decided to handle them as a *single* architecture.
>
> Keeping ARCH=i386 and ARCH=x86_64 around is just a way to pretend
> this is two diffrent architectures which is no longer the case.
>
> Do we need a way to say "build a kernel that is 64 bit"?
> If we need this then we should look at the most intuitive way
> to say so and this should work across x86, powerpc and s390.
>
> 	make 64BIT=y ARCH=x86
>
> looks so much more intuitive. And it is generic.
> This is just a proposal.
>
> But lets focus on finding a generic solution and not try
> to hang around in old habbits.

I agree. So long as you can do it easily on the commandline, it's
no problem, and we should be consistent (in calling the arch x86).
