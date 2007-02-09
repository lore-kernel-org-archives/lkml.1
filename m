Return-Path: <linux-kernel-owner+w=401wt.eu-S1946574AbXBIPjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946574AbXBIPjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946561AbXBIPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:39:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946575AbXBIPjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:39:10 -0500
Date: Fri, 9 Feb 2007 07:38:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081715020.30410@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702090730260.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081643280.30166@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081705300.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081715020.30410@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, David Rientjes wrote:
> 
> Yes, I read the 4.1.1 docs:
> 
> 	By default, such a bit-field is signed, because this is
> 	consistent: the basic integer types such as int are signed
> 	types.

Ok, so the gcc people have added some language. So what? The fact is, that 
language has absolutely nothing to do with the C language, and doesn't 
change anything at all.

> That is the whole basis for my argument, when you declare something "int," 
> most programmers would consider that to be SIGNED regardless of whether it 
> is 32 bits, 13 bits, or 1 bit.

And MY argument is that YOUR argument is CRAP.

The fact is, signs of bitfields, chars and enums aren't well-defined. 
That's a FACT.

Your argument makes no sense. It's like arguing against "gravity", or like 
arguing against the fact that the earth circles around the sun. It us 
STUPID to argue against facts.

Your argument is exactly the same argument that people used to say that 
the earth is the center of the universe: "because it makes sense that 
we're the center". 

The fact that "most programmers" or "it makes sense" doesn't make anything 
at all true. Only verifiable FACTS make something true.

There's a great saying: "Reality is that which, when you stop believing in 
it, doesn't go away." - Philip K Dick.

So wake up and smell the coffee: reality is that bitfields don't have a 
specified sign. It's just a FACT. Whether you _like_ it or not is simply 
not relevant.

The same is true of "char". You can argue that it should be signed by 
default, sicne "short", "int" and "long" are signed. But THAT IS NOT TRUE.

Arguing against reality really isn't very smart.

		Linus
