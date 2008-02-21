Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbYBUBZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbYBUBZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYBUBZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:25:33 -0500
Received: from crca.org.au ([67.207.131.56]:58503 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYBUBZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:25:32 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47BCD305.8080206@nigel.suspend2.net>
Date: Thu, 21 Feb 2008 12:25:25 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net> <20080221001357.GA29796@srcf.ucam.org> <47BCC866.9000102@nigel.suspend2.net> <20080221011032.GA30606@srcf.ucam.org>
In-Reply-To: <20080221011032.GA30606@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Matthew Garrett wrote:
> On Thu, Feb 21, 2008 at 11:40:06AM +1100, Nigel Cunningham wrote:
>> Matthew Garrett wrote:
>>> No, with a freezer-based model you can basically *never* suspend to 
>>> anything related to FUSE or a userspace USB device or anything involving 
>>> userspace iSCSI initiators or whatever. Sure, there are cases where 
>>> moving away from the current model doesn't buy you anything, but that 
>>> doesn't mean that the current model is a good thing. It's not. The 
>>> freezer is a fundamentally broken concept.
>> Putting drivers and filesystems in userspace is the fundamentally broken 
>> concept. Not just when it comes to the freezer. The whole idea is 
>> inherently racy. You can draw silly diagrams about how the freezer 
>> supposedly works in LCA slides and spread FUD as much as you like. In 
>> the end, though, it's not nearly as hit-and-miss as you say, and 
>> replacing the freezer with a kexec based freezer is only going to create 
>> as many problems as it removes.
> 
> I'm really not interested in debating the matter. There are all sorts of 
> potential uses for the freezer, but hibernation isn't one of them. We 
> *need* to get rid of the freezer for suspend to RAM (because a band-aid 
> to ensure atomicity is kind of pointless when the operation you're 
> entering is inherently atomic), and once all the drivers are able to 
> deal with that then it's trivial to get rid of it for hibernation as 
> well. Arguing that the reality of userspace drivers is broken doesn't 
> help here. It's what we have to work with.

Re suspend to ram, I agree. No argument there. Re hibernation, I think 
your assertion that it will be trivial to get rid of it for hibernation 
is just plain wrong. Perhaps you don't understand the issues as well as 
you think you do.

Re arguing that the reality of userspace drivers is broken doesn't help 
here: Yeah, I know. But sometimes if you point out broken ideas for long 
enough, people do actually listen. Or you learn. Or both.

Frankly, I don't want to debate the issue either. What I really want is 
just to have a hibernation implementation that works, is flexibile, 
reliable and quick, and one that I don't have to keep maintaining. 
Unfortunately for me, most people seem to be more concerned with fixing 
hypothetical problems than with giving users something they can actually 
use.

>>> You're looking at a tiny amount of memory when compared to current 
>>> systems. It's really not a problem.
>> Please, quantify 'tiny'. In embedded, 5MB can be too much. I've worked 
>> on embedded solutions. I'm not pulling problems out of thin air.
> 
> Then the in-kernel solution has already lost anyway, and I'm desperately 
> unconcerned about out of tree stuff.

I know. I'd submit it, or work on breaking it into pieces and submitting 
them one at a time, but that seems to me to be a waste of time.

Nigel
