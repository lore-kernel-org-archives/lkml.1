Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZFWTtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZFWTtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZFWTtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:49:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756635AbZFWTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:49:40 -0400
Date: Tue, 23 Jun 2009 12:49:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jake Edge <jake@lwn.net>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [PATCH v3.1415] Documentation: add documentation summary for
 rc-series and merge window
In-Reply-To: <m3y6rilorn.fsf@intrepid.localdomain>
Message-ID: <alpine.LFD.2.01.0906231246430.3240@localhost.localdomain>
References: <20090622222217.GH23972@bombadil.infradead.org> <m3fxdqj2bz.fsf@lwn.net> <m3bpoen5pp.fsf@intrepid.localdomain> <20090623130602.6cd6b713@chukar> <alpine.LFD.2.01.0906231210040.3240@localhost.localdomain> <m3y6rilorn.fsf@intrepid.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jun 2009, Krzysztof Halasa wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > In fact, this whole discussion has shown one thing: people still think 
> > that "bug fix" somehow automatically means that it's appropriate after the 
> > merge window. That's simply not so. 
> 
> That's why i wrote: gain vs risk.

People really don't seem to be very good at the risk management part. They 
see the gain, they don't think about the risk.

Note: not all maintainers are bad about this. But it tends to be my 
biggest gripe after around -rc3 or so - people send stuff that is good, 
but that really has no real reason not to be delayed.

And as long as people talk about this in terms of "bugs", it's a problem.

It would be much better to talk about it in terms of "Does this _really_ 
have to hit the next release? Honestly? Even though we're supposed to be 
in the calming-down period?"

			Linus
