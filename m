Return-Path: <linux-kernel-owner+w=401wt.eu-S1030390AbXBOTDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390AbXBOTDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030395AbXBOTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:03:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030390AbXBOTDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:03:05 -0500
Date: Thu, 15 Feb 2007 11:02:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergei Organov <osv@javad.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       =?ISO-8859-1?Q?J=2EA=2E_Magall=C3=C3=C3=C3=C3=C2=B3n?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87k5yjjlrj.fsf@javad.com>
Message-ID: <Pine.LNX.4.64.0702151059090.20368@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
 <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
 <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
 <87ps8end9b.fsf@javad.com> <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
 <87bqjxooog.fsf@javad.com> <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
 <87fy99n6mf.fsf@javad.com> <Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org>
 <87hctnlfqz.fsf@javad.com> <Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
 <87k5yjjlrj.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Sergei Organov wrote:
> 
> I agree that if the warning has no true positives, it sucks. The problem
> is that somehow I doubt it has none. And the reasons for the doubt are:

Why do you harp on "no true positives"?

That's a pointless thing. You can make *any* warning have "true 
positives". My personal favorite is the unconditional warning:

	warning: user is an idiot

and I _guarantee_ you that it has a lot of true positives.

It's the "no false negatives" angle you should look at.

THAT is what matters. The reason we don't see a lot of warnings about 
idiot users is not that people don't do stupid things, but that 
*sometimes* they actually don't do something stupid.

Yeah, I know, it's far-fetched, but still.

In other words, you're barking up *exactly* the wrong tree. You're looking 
at it the wrong way around.

Think of it this way: in science, a theory is proven to be bad by a single 
undeniable fact just showing that it's wrong.

The same is largely true of a warning. If the warning sometimes happens 
for code that is perfectly fine, the warning is bad.

		Linus
