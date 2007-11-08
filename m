Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbXKHDXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbXKHDXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 22:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbXKHDXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 22:23:34 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754096AbXKHDXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 22:23:33 -0500
Date: Thu, 8 Nov 2007 04:23:08 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function
	`usbnet_set_settings':
Message-ID: <20071108032308.GE26163@stusta.de>
References: <200711012024.57412.toralf.foerster@gmx.de> <200711071434.52607.david-b@pacbell.net> <20071107225232.GB26163@stusta.de> <200711071853.48460.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711071853.48460.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 06:53:48PM -0800, David Brownell wrote:
> On Wednesday 07 November 2007, Adrian Bunk wrote:
> > On Wed, Nov 07, 2007 at 02:34:52PM -0800, David Brownell wrote:
> > > > > But on the other hand, it seems that only the ASIX code will work
> > > > > right; the DM9601 and MCS7830 Kconfig is different/wrong.
> > > > 
> > > > I'm not seeing the problem.
> > > > 
> > > > Which configuration will be handled wrongly?
> > > 
> > > Notice how only the ASIX kconfig depended on NET_ETHERNET...
> > > since MII depends on NET_ETHERNET, and (last I knew) the
> > > reverse dependencies didn't capture the complete dependency
> > > tree, selecting only MII would leave out some stuff.
> > 
> > Except for one s390 net driver (I'll check why it's doing this) the 
> > NET_ETHERNET option does not influence what code is being generated - 
> > it's just a Kconfig-internal option allowing to disable a huge bunch
> > of drivers at once.
> 
> Drivers like ... AX88xxx, DM9601, and MCS7830!!  Except as
> it turns out, only the first one behaves as intended.
> 
> You can tell it's a problem by the way it's inconsistent,
> regardless of the details of the problem.  :)

I'm all for cleanups that make things consistent.  :)

As long as we can agree that there's a difference between a problem like 
a compile or runtime error and an opportunity for making things 
consistent.

> - Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

