Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZGBWAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZGBWAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZGBWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:00:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38069 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZGBWAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:00:08 -0400
Date: Fri, 3 Jul 2009 00:00:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702220004.GF1485@ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19019.16217.291678.588673@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > Defaults should be back-compatible.
> 
> I would usually agree, but I think we have an unusual situation here,
> in some ways similar to a demonstrated security hole. The previous
> behaviour exposed a lot of Linux vendors to the possibility of an
> expensive legal fight.

I'd actually like to see all-out software patent war in the U.S. It
would make sure that software patents do not spread to the rest of
world. Bad for U.S.? Yes. Good for world? Yes!

>  > Users considering disabling this should understand that filesystem
>  > they write to will not be valid vfat filesystems, and may trigger bugs
>  > in some devices.
> 
> If we find any devices that exhibit any problems with this patch while
> it is in linux-next (and maybe linux-mm?) then this warning would
> indeed be appropriate. It no such devices are known then I think the
> warning is going a bit far. 

You already know that it breaks XP and older linuxes. So... what are
you arguing about?! Chkdsk marks it as invalid filesystem... not a
vfat.

If mickey$oft intentionally modified windows 8 to intentionally corrupt
ext3 filesystems so that linux oopses on accessing them, how'd you
like that?

>  > Why not use something like position in directory instead of random
>  > number?
> 
> We did of course consider that, and the changes to the patch to
> implement collision avoidance are relatively simple. We didn't do it
> as it would weaken the legal basis behind the patch. I'll leave it to

Consider it again. Or put fair 'this makes XP crash' warning in
kconfig.

								Pavel
PS: I find it bad that original patch description did not contain XP
crashing / chkdsk explanation.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
