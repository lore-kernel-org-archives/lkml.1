Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbXBMTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbXBMTZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbXBMTZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:25:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49071 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXBMTZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:25:33 -0500
Date: Tue, 13 Feb 2007 11:25:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <osv@javad.com>
cc: =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C3=C2=B3n?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87ps8end9b.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <20070208221317.5beedaeb@werewolf-wl> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
 <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
 <87ps8end9b.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Feb 2007, Sergei Organov wrote:
> >
> > 	"I want a char of indeterminate sign"!
> 
> I'm afraid I don't follow. Do we have a way to say "I want an int of
> indeterminate sign" in C? The same way there doesn't seem to be a way
> to say "I want a char of indeterminate sign".

You're wrong.

Exactly because "char" *by*definition* is "indeterminate sign" as far as 
something like "strlen()" is concerned.

"char" is _special_. Char is _different_. Char is *not* "int".

> So no, strlen() doesn't actually say that, no matter if we like it or 
> not. It actually says "I want a char with implementation-defined sign".

You're arguing some strange semantic difference in the English language.

I'm not really interested.

THE FACT IS, THAT "strlen()" IS DEFINED UNIVERSALLY AS TAKING "char *".

That BY DEFINITION means that "strlen()" cannot care about the sign, 
because the sign IS NOT DEFINED UNIVERSALLY!

And if you cannot accept that fact, it's your problem. Not mine.

The warning is CRAP. End of story.

		Linus
