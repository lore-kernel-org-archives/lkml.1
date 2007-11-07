Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbXKHBUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbXKHBUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXKHBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:20:37 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35447 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbXKHBUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:20:36 -0500
Date: Wed, 7 Nov 2007 23:52:32 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function
	`usbnet_set_settings':
Message-ID: <20071107225232.GB26163@stusta.de>
References: <200711012024.57412.toralf.foerster@gmx.de> <200711021230.22588.david-b@pacbell.net> <20071102195517.GW30287@stusta.de> <200711071434.52607.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711071434.52607.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:34:52PM -0800, David Brownell wrote:
> > > But on the other hand, it seems that only the ASIX code will work
> > > right; the DM9601 and MCS7830 Kconfig is different/wrong.
> > 
> > I'm not seeing the problem.
> > 
> > Which configuration will be handled wrongly?
> 
> Notice how only the ASIX kconfig depended on NET_ETHERNET...
> since MII depends on NET_ETHERNET, and (last I knew) the
> reverse dependencies didn't capture the complete dependency
> tree, selecting only MII would leave out some stuff.

Except for one s390 net driver (I'll check why it's doing this) the 
NET_ETHERNET option does not influence what code is being generated - 
it's just a Kconfig-internal option allowing to disable a huge bunch
of drivers at once.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

