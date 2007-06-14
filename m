Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXFNOLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXFNOLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXFNOLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:11:36 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15109 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbXFNOLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:11:35 -0400
X-IronPort-AV: i="4.16,421,1175486400"; 
   d="scan'208"; a="42146713:sNHT33753384"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 10:14:21 -0400
User-Agent: KMail/1.9.5
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706132304.21984.dhazelton@enter.net> <ork5u7i0oi.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ork5u7i0oi.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141014.21574.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 14 Jun 2007 14:11:32.0541 (UTC) FILETIME=[E8F60ED0:01C7AE8D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14 Jun 2007 01:07, Alexandre Oliva pondered:
> On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> 
> > User B buys the router and modifies the kernel so it drives the WiFi
> to an 
> > output power twice that which it is licensed to carry.
> > FCC finds out and prosecutes User B for violating the regulations.
> 
> Ok so far.
> 
> > FCC then pulls the small companies license until they change their
> > hardware so the driver can't push it to transmit at a higher power
> > level and levies a fine.
> 
> I'd say this is unfair, but if it can happen, 

it can (at least hypothetically in the US - I do not know of any actual 
cases - anyone?).

> then maybe the small 
> company could have been more careful about the regulations.  There are
> various ways to prevent these changes that don't involve imposing
> restrictions of modification on any software in the device, all the
> way from hardware-constrained output power to hardware-verified
> authorized configuration parameters.

As a person pretty familiar with the hardware in these types of devices - this 
just isn't practical. 

The power output goes to the air, has some to do with any external power amp, 
the antenna design/connectors, the layout of the printed circuit board (PCB), 
the materials of the PCB, and numerous other factors that are outside the 
chip where the register sits that controls the "output power". This is why 
the register is there - so many things exist in the real world that require 
it to be changed to actually get desired power output in the air.

What you are asking is possible - that people who make the standard CMOS 
radios add EEPROM or FLASH to their processes - or they could add an 
interface to a serial EEPROM where these hardware limits could sit - and 
during manufacturing could program these to add a hardware limit.

But this seems - just silly - adding extra cost/complexity to the hardware - 
because you limit things in the zero-cost space?

Or run the driver in user space, and forget about it. (Like everyone is 
starting to do on the desktop).

> When this doesn't bring freedom to people, when people can't actually
> enjoy the freedoms that the software is supposed to provide, I don't
> see why this would be a good thing.  What's the merit in being able to
> claim "vendor X chose my Free Software and locked it down such that
> users don't get the freedoms I meant for them, and I'm happy about it?"

Sometimes joy comes from knowing that your contribution was valuable.

I would ask about two other examples:

 - medical devices - which must have their software certified by the FDA (at 
least in the US) - and the manufacture can not allow non-certified software 
to be loaded on it - and would be classified "designed or sold for 
incorporation into a dwelling" (per the GPL3 dd1v3). Think devices like :

http://www.powerheart.com/products/ [1]

Are Linux developers "happy" knowing their contributions will never help save 
a life? And this joy goes to Microsoft or VxWorks? Today it can go to Linux 
developers, since the GPL2 license doesn't restrict this like the GPL3 does.


 - gambling devices - which must have their software certified by various 
government agencies - to make sure that the odds are known, and there are no 
backdoors, and consumers don't get screwed - the manufacture can not allow 
non-certified software to be loaded on it. If these are in a hotel - where 
various people live - is that considered "incorporation into a dwelling"?

Not wanting to start a debate about the morality of being involved in the 
gambling industry - (if the statically challenged are giving the government 
money to keep my taxes down, I am mostly OK with it) - but I'm not "happy" 
thinking that someone can ledgistate restrictions on embedded OS choice, just 
because it must be verified by a third party.


Hypothetically - tragedy strikes - use of a modified Nao robot [2] contributes 
to someone's death (remember - modifications of the OS removed the three 
laws). Someone (maybe Microsoft or VxWorks, or GreenHills) steps up, and 
lobbies the government - that embedded OSes need tighter control to ensure 
safety - and need to be validated by the government. (like the FCC and FDA is 
already doing in the US).

Since the GPL3 states" - 
"If you cannot convey the Program, or other covered work, so as to satisfy 
simultaneously your obligations under this License and any other pertinent 
obligations, then as a consequence you may not convey it at all."

Forget DRM - forget Tivo - anyone who develops a product which must be 
certified can not use anything that is under the GPL3.

On Sun, 10 Jun 2007 10:29:04 Linus Torvalds pondered:
> I still think GPLv2 is simply the better license.
>
> I consider dual-licensing unlikely (and technically quite hard), but at 
> least _possible_ in theory. I have yet to see any actual *reasons* for 
> licensing under the GPLv3, though.

I think there are actual reasons _not_ to.

What I have told people who have asked me (who are thinking about putting 
Linux in a medical device) is kernel version 2.6.xx (current version at the 
time), is released under GPL2.  No one can go back and change the license on 
a previously released package. 

It might be easier to say that the kernel licence will only be reviewed during 
a major bump in the kernel version number (3.x.x) and that all 2.x kernels 
will be under the same license as what exists today.

-Robin

[1] - I don't know if this device has Linux in it or not - but this just 
represents classes of devices that may never be able to use Linux.

[2]  http://linuxdevices.com/news/NS6263763539.html
