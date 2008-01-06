Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYAFMiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYAFMiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYAFMiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:38:03 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48792 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYAFMiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:38:01 -0500
Date: Sun, 6 Jan 2008 14:37:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080106123728.GD2082@does.not.exist>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780C728.1030806@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4780C728.1030806@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:18:48PM +0100, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Sun, Jan 06, 2008 at 01:35:21AM +0100, Stefan Richter wrote:
> >> Adrian Bunk wrote:
> >>> Whether or not an option requires an additional subsystem like e.g. SCSI 
> >>> or SSB are hardware and implementation details we shouldn't bother 
> >>> kconfig users with.
> >> What is an implementation detail and what is not?  In the end,
> >> everything that we configure in Kconfig is implementation details.
> > 
> > With the use case "system administrator" we can expect people to know 
> > the name of their ethernet card and which filesystems they use, but we 
> > should not bother them with the fact that their network card might 
> > require the Sonics Silicon Backplane support.
> 
> I'm afraid this can't be put into practice.  (User says which hardware
> and protocols he needs to be supported, scripts magically assemble a
> suitable configuration.)

Distribution installers and live CDs like Knoppix even manage to 
magically assemble a suitable configuration (e.g. autodetecting which 
modules they should load) without asking the user any questions.

The information the user has to give when configuring his kernel is 
whether he wants to connects USB disks - whether or not the 
implementation of the kernel driver uses the in-kernel SCSI layer we can 
easily handle automatically without bothering the user.

> I think
>   - sensibly modularize our software,
>   - tell the user which software components there are,
>   - what they are for,
>   - how they depend on each other,
>   - make it easy enough for the user to navigate in the dependency
>     graph,
>   - provide fundamental safeguards and checks for a proper software
>     configuration
> is the best we can do.

It sounds strange that what you call the "the best we can do" would be 
much worse than what we are currently doing...

The current status quo is that a user e.g. only has to know that his 
ethernet controller is a "Broadcom 440x/47xx", the fact that a Sonics 
Silicon Backplane bus is used on the card is handled automatically by 
kconfig.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

