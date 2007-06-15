Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbXFOQcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbXFOQcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXFOQcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:32:08 -0400
Received: from srv1.netkinetics.net ([206.71.148.180]:55009 "EHLO
	srv1.netkinetics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbXFOQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:32:06 -0400
Subject: Re: Dual-Licensing Linux And Medical Devices
From: Tim Post <tim.post@netkinetics.net>
Reply-To: tim.post@netkinetics.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Poole <mdpoole@troilus.org>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
In-Reply-To: <alpine.LFD.0.98.0706142118410.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	 <200706142049.41819.dhazelton@enter.net>
	 <87fy4u0xty.fsf@graviton.dyn.troilus.org>
	 <200706142246.57583.dhazelton@enter.net>
	 <878xal2a0q.fsf@graviton.dyn.troilus.org>
	 <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org>
	 <874pl928r6.fsf@graviton.dyn.troilus.org>
	 <alpine.LFD.0.98.0706142118410.14121@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Net Kinetics
Date: Sat, 16 Jun 2007 00:27:41 +0800
Message-Id: <1181924861.21797.240.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv1.netkinetics.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - netkinetics.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 21:23 -0700, Linus Torvalds wrote:
> 
> On Thu, 14 Jun 2007, Michael Poole wrote:
> > 
> > If the signature is one that serves to indicate origin, to detect
> > tampering, or the other things you mentioned, the program's binary is
> > useful when separated from the signature.  My objection arises when a
> > functionally equivalent binary -- including advertised functions such
> > as "runs on platform XYZ" -- cannot be produced from the distributed
> > source code.
> 
> Ahh.
> 
> Ok, that's a totally different issue, and is one where I heartily agree 
> with you. I would actually *love* for the GPL (any version) to have a 
> "guarantee of authenticity", where if you distribute a binary, there has 
> to be some documented way to get *exactly* that binary out of the source 
> code that got distributed.

I would hope that this is *required*, somehow, when dealing with medical
equipment. I don't think those appliances even have the capacity to
build every upgrade from source. None that I've tinkered with do. These
things almost need a license of their own.

As long as the signing mechanism can't be used to force clinics to pay
for the privilege of upgrading free software, that is. It would truly
suck if an ultrasound loaded with free software sat in a corner useless
because a free clinic could not afford to pay for what they already paid
for.

If you guys can find a way to make that practical given my above
concerns, that would be entirely useful. I hate the fact that this kind
of trust is needed because it is so very easily mis-used, but people
dying due to hacked IV regulators really wouldn't much care about those
politics.

I think, also privacy implications for patients. A rootkit in a MRI
would be very bad.

Regardless, like it or not, kernel code is in or headed for medical
devices, so I hope some more brain power is burned on this. 

Best,
--Tim

