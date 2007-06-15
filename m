Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXFOClx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXFOClx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXFOClq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:41:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbXFOClp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:41:45 -0400
Date: Thu, 14 Jun 2007 22:39:44 -0400
From: Bill Nottingham <notting@redhat.com>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Florin Malita <fmalita@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615023944.GC3760@nostromo.devel.redhat.com>
Mail-Followup-To: Alexandre Oliva <aoliva@redhat.com>,
	Florin Malita <fmalita@gmail.com>,
	Daniel Hazelton <dhazelton@enter.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
	david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org> <ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br> <200706140305.50095.dhazelton@enter.net> <orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br> <46717C58.8050501@gmail.com> <ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br> <4671A528.5040300@gmail.com> <or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614234507.GA3860@nostromo.devel.redhat.com> <or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or1wge6jii.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Oliva (aoliva@redhat.com) said: 
> > Wait, a signed filesystem image that happens to contain GPL code
> > is now a derived work? Under what sort of interpretation does *that*
> > occur?
> 
> Is the signature not derived from the bits in the GPLed component, as
> much as it is derived from the key?
> 
> Isn't the signature is a functional portion of the image, i.e., if I
> take it out from the system, it won't work any more?
> 
> > (This pretty much throws the 'aggregation' premise in GPLv2 completely
> > out.)
> 
> Not really.  It could take some explicit distinguishing between
> functional and non-functional signatures, but that's about it.

OK. Let's take this to the simple and logical conclusion. A signed
filesystem image containing both GPL and non-GPL code. From your
point A, this is a derived work. 

Let's read the license...

2. b) You must cause any work that ... is derived from the Program or any
   part thereof, to be licensed as a whole at no charge to all third
   parties under the terms of this License.

...
 But when you
 distribute the same sections as part of a whole which is a work based
 on the Program, the distribution of the whole must be on the terms of
 this License, whose permissions for other licensees extend to the
 entire whole, and thus to each and every part regardless of who wrote it.
 
and yet later:

In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

Pick one. They can't both be valid.

Moreover, this interpretation means that Red Hat (and pretty much
any other Linux distributor) should close up shop, as that's what
we've been doing for years.

Bill
