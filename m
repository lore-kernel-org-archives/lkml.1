Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXIYPb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXIYPb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXIYPbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:31:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42302 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753144AbXIYPbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:31:50 -0400
Date: Tue, 25 Sep 2007 17:32:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <david@davidnewall.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug (was: sys_chroot+sys_fchdir Fix)
Message-ID: <20070925153208.GO6800@stusta.de>
References: <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46F924E3.50205@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 12:40:27AM +0930, David Newall wrote:

> Miloslav Semler pointed out that a root process can chdir("..") out of its 
> chroot.  Although this is documented in the man page, it conflicts with the 
> essential function, which is to change the root directory of the process.  
> In addition to any creative uses, for example Philipp Marek's loading 
> dynamic libraries, it seems clear that the prime purpose of chroot is to 
> aid security.  Being able to cd your way out is handy for the bad guys, but 
> the good guys don't need it; there are a thousand better, safer solutions.
>...

The bad guys most likely also now other tricks to escape the chroot.

If you are root in the chroot you can e.g. mount the partition with the 
root filesystem inside the chroot.

If a bad guy becomes root inside a chroot it's game over.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

