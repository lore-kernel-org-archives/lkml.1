Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXCWTPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXCWTPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXCWTPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:15:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32947 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753409AbXCWTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:15:14 -0400
Date: Fri, 23 Mar 2007 20:15:18 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David L <idht4n@hotmail.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070323191518.GU752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185028.GR752@stusta.de> <1174677338.10840.321.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1174677338.10840.321.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 08:15:38PM +0100, Thomas Gleixner wrote:
> On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> > Subject    : gettimeofday increments too slowly
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8027
> > Submitter  : David L <idht4n@hotmail.com>
> > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >              commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > Status     : problem is being debugged
> 
> Patch available: http://lkml.org/lkml/2007/3/22/301
> 
> commit 6b3964cde70cfe6db79d35b42137431ef7d2f7e4

As far as I understood it, this patch only fixed the bogomips issue
caused by commit e9e2cdb412412326c4827fc78ba27f410d837e6e, but not the 
gettimeofday issue caused by commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2 ?

> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

