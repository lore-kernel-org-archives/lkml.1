Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYDVABV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYDVABV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYDVABE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:01:04 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54147 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbYDVABC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:01:02 -0400
Date: Tue, 22 Apr 2008 03:00:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [2.6 patch] remove the v850 port
Message-ID: <20080422000030.GN2633@cs181133002.pp.htv.fi>
References: <248552034@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <248552034@web.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:38:49AM +0200, devzero@web.de wrote:
> I can't afford to be critical here, but let me give a comment.
> 
> i think putting this in feature-removal-schedule.txt just good practice.
> you give people the chance to catch up - sort of a last reminder to the devs "fix it or we need to drop it".
> some chance for the users to see it will go away and make early decision based on that.
> 
> i like those cleanup efforts, but even if it was announced on lkml, or elsewhere - that file is the official place for such announcements and if you want people take care of that file, there should be reliable information inside. 
> 
> it often takes much effort and hard work to get code into the kernel, so some "nah, this is broken, doesn`t compile for long - put that to trash" seems a little bit harsh for me.
> 
> the reason why it`s broken is probably not the v850 people`s fault. 
> ok, they just didn`t catch up with that "kernel progress" - but most probably some other person broke their code.
> 
> i don`t like bureaucracy, but a little bit of bureaucracy at the right place is not that bad at all.....

As the patch description says it does not even compile since at
least kernel 2.6.19 (which was released in 2006).

I've sent this removal patch 7 times during 3 months to linux-kernel.

Before that I sent 2 emails to linux-kernel asking about the status of 
the port.

All emails also got to Miles, the maintainer of the port.

Without the slightest sign of anyone claiming he might work on fixing 
this port.

Greg (one of the uClinux core maintainers) said the only one he knows 
who can maintain the port is Miles.

If there's not a single person on linux-kernel who is either interested 
in this port or at least knows someone who is, then requiring to put it 
into some file in the kernel sources is actually quite high on the scale 
of pointless bureaucracy.

> roland

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

