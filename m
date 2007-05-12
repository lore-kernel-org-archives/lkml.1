Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbXELVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbXELVLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXELVLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:11:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32813 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754252AbXELVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:11:43 -0400
Date: Sat, 12 May 2007 23:11:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070512211144.GO7984@stusta.de>
References: <1178550653.11851.191.camel@pmac.infradead.org> <20070507194949.GB3981@ucw.cz> <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com> <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl> <1178646751.2824.48.camel@pmac.infradead.org> <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl> <1178721996.2824.199.camel@pmac.infradead.org> <20070509203335.GA4290@ucw.cz> <1178887402.21820.65.camel@shinybook.infradead.org> <20070511132116.GH4052@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070511132116.GH4052@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 01:21:16PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > > > And how about serial terminals?
> > > > 
> > > > It works fine over serial terminals. Why wouldn't it?
> > > 
> > > He probably means serial terminals... like physical vt100. I used to
> > > have one (vt302 compatible or something).  Most emulators still
> > > emulate vt100, and yes, vt100 predates utf-8. 
> > 
> > I have a serial terminal which can only do lower case (well, actually
> > capitals but it's all mapped to lower case since that's more useful).
> > 
> > When I write code on it, I can't do capital letters. But do I try to
> > _force_ you to use only capitals because of my limited terminal?
> 
> If I wrote int j, J; in my code, you'd have valid case wanting me to
> fix it. And I simply want you to fix useless uses of utf-8. And evil
> uses utf8, like int voltage; /* ??V */. I do not know what is so hard
> to understand.
> 
> You are intentionally making code hard to read. Stop trying to merge
> that crap.

It was °C, and that's IMHO better readable than some kind of "degrees C".

Only using 7bit ASCII might have been a good advice in the last 
millenium. But in the current millenium, most environments handle UTF-8 
just fine.

And we are only talking about documentation and comments - IOW, things 
not visible for someone running a kernel. Code (including printk's) must 
stay 7bit ASCII.

In the worst case, if you managed to find a not UTF-8 capable 
environment for viewing the kernel sources, the few characters that are 
not 7bit ASCII are displayed incorrectly, and you'll have to guess which 
character someone might place in front of a "C" describing something 
named wBAT_TEMP (you will likely guess it correctly).

And it's nothing new, comments containing non 7bit ASCII characters are 
already present in 10 year old kernels (often, but not limited to,
developer's names).

> 							Pavel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

