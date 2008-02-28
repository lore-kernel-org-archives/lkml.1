Return-Path: <linux-kernel-owner+w=401wt.eu-S932707AbYB1X1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbYB1X1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbYB1X1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:27:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:40173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbYB1X1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:27:37 -0500
Subject: Re: [PATCH 1/2] firewire: endianess fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jarod Wilson <jwilson@redhat.com>
Cc: Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       sparclinux@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <200802281342.06493.jwilson@redhat.com>
References: <20080220220326.GA22328@uranus.ravnborg.org>
	 <200802272221.38985.jwilson@redhat.com>
	 <1204179959.15052.372.camel@pasglop>
	 <200802281342.06493.jwilson@redhat.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 10:26:02 +1100
Message-Id: <1204241162.15052.393.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 13:42 -0500, Jarod Wilson wrote:
> On Thursday 28 February 2008 01:25:59 am Benjamin Herrenschmidt wrote:
> > > Under Mac OS X, system.log says "FireWire (OHCI) Apple ID 31 built-in now
> > > active". Could still be lucent though, judging by the subsys device ID of
> > > 5811, which matches up w/the Lucent/Agere FW323. But no, apparently I
> > > don't have the interesting one.
> >
> > Well, it's interesting in the sense that it's a "normal" OHCI then on a
> > BE machine :-) My Pismo, which had the weirdo one, unfortunately died a
> > while ago. I'll see if I can find another machine with that one in.
> 
> Ah, the pismo has it, eh? I think I may actually know of someone in the office 
> that still has one of those that I might be able to borrow and poke at...

I -think- it has it... Pismo definitely has one of the first variant of
UniNorth with "working" FW afaik.

The first UniNorth was used in the first "toilet-seat" ibook, but I
think this one didn't have firewire, or a non-working one... and in the
first Sawtooth G4 for which FW and Ethernet even were separate PCI chips
because the ones in UniNorth were too broken.

It's possible that early G4 titanium powerbooks or other model of FW
iBooks have that UniNorth FW variant too.

Ben.


