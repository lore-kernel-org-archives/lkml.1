Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYBQNQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYBQNQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYBQNQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:16:40 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57332 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYBQNQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:16:39 -0500
Date: Sun, 17 Feb 2008 15:16:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080217131611.GA1403@cs181133002.pp.htv.fi>
References: <200802171025.30590.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200802171025.30590.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:25:30AM +0100, Frans Pop wrote:
>...
> For my work on the Debian Installer I heavily rely on emulators to run test 
> installs and ATM my emulator of choice is VirtualBox (the fully open "ose" 
> version). This requires the vboxdrv kernel module, but unfortunately:
>...
> OF COURSE it is up to the VirtualBox developers to adjust to the new 
> interface (and based on past experience I expect they will with their next 
> version). And it may very well be that they were totally braindead to use 
> the function in the first place. I don't know and I really don't care.
> The important fact for me is that I can no longer use a piece of software 
> that is essential to me and thereby lose the motivation to do any work on 
> the kernel.
> 
> Lesson of the day: thinking only about in-kernel users of published API when 
> doing restructuring is going to lose you testers who do MORE with their 
> systems than just kernel development.
>...

I get your problem, but you are looking in the wrong direction for
a solution.

The real problem is that the kernel seems to lack functionality you 
require for doing some work.

Why does your work on the Debian Installer depend on VirtualBox and
can't be done with what the kernel already ships?

> Thanks,
> FJP
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

