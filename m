Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbZGGTvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbZGGTvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZGGTvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:51:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35130 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZGGTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:51:37 -0400
Date: Tue, 7 Jul 2009 21:51:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090707195129.GB24203@elf.ucw.cz>
References: <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org> <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19025.63119.656216.431469@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-06 23:05:19, tridge@samba.org wrote:
> Hi Jan,
> 
>  > With this extra patch:
>  > 
>  >  * "cp dscf4160.jpg dscf3010.jpg" works
> 
> good
> 
>  >  * "cp dscf4160.jpg dscF3011.jpg" does not work - i.e. cam ignores the
>  >    file without error.
>  >    Reason for that is that dscF3011 has an illegal 8.3 name
> 
> yep, that's expected. I suggested a possible way of handling this to
> Hirofumi-san (ie. change the case of the name), but he prefers to keep
> things simple for now.
> 
> It is probably not unreasonable to say that you should not be using
> mixed case names when you are putting files onto a device that doesn't
> understand mixed case. The reason it worked before my patch is that
> the kernel forced the case of the 8.3 name, and only retained the
> mixed case for the long name.

It worked before. You claim that devices not understanding long
filenames are now extinct, but that camera is the
counterexample. Perhaps camera vendors fear patents, too.

So the original description is bad -- it breaks also new stuff -- and
it certainly should not be default=y.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
