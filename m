Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYGOWTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYGOWTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYGOWTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:19:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35453 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYGOWTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:19:47 -0400
Date: Wed, 16 Jul 2008 01:19:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715221941.GM24533@cs181140183.pp.htv.fi>
References: <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <1216149637.27242.65.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150288.27242.75.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151233580.3351@woody.linux-foundation.org> <1216151085.27242.86.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1216151085.27242.86.camel@violet.holtmann.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 09:44:45PM +0200, Marcel Holtmann wrote:
> Hi Linus,
> 
> > > Personally I am against hacking file loading from within the kernel.
> > > This is why we involved udev (or hotplug in the beginning). It allows
> > > you to have userspace policy for the search paths etc.
> > 
> > Well, I'm personally against _forcing_ people to use udev. 
> > 
> > Yes, desktop distros generally will do so, since there are lots of complex 
> > issues etc. But I don't think we've generally forced it on people if they 
> > don't want it (ie I haven't tried it personally since the distro I used 
> > started using udev, but I think you can still just ignore udev events and 
> > set everything up statically).
> > 
> > And I don't think that's wrong. Which implies that setup things should 
> > still generally at least allow us to avoid udev.
> > 
> > (But maybe I'm wrong, and everybody already uses udev just because they 
> > couldn't be bothered not to).
> 
> I actually think that is the case here. udev is so lightweight and
> really slim nowadays that not using it is a big drawback. There might be
> some system out there that are still using a static /dev directory, but
> for sure there are not many and even the embedded world doesn't really
> mind.
>...

Depends on which embedded systems you look at.

For MID devices that's definitely true, but there are also today still 
cases where customers want fast startup times on < 200 MHz embedded 
devices, and when every second counts you don't want to add a
"Waiting for /dev to be fully populated" from udev to the bootup.

(And on my computer (whose Linux installation predates the inclusion of 
 devfsd (sic) into the kernel) the static /dev also still works fine.)

> Regards
> 
> Marcel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

