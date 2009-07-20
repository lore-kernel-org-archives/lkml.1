Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZGTVfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZGTVfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZGTVfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:35:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZGTVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:35:36 -0400
Date: Mon, 20 Jul 2009 14:33:41 -0700
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Sam Ramji <sramji@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       devel@driverdev.osuosl.org, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720213341.GB1781@kroah.com>
References: <20090720160025.GA20249@kroah.com>
 <alpine.LSU.2.00.0907202304180.1353@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.00.0907202304180.1353@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:24:24PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2009-07-20 18:00, Greg Kroah-Hartman wrote:
> >
> >I'm happy to announce, that after many months of discussions, Microsoft
> >has released their Hyper-V Linux drivers under the GPLv2.  Following
> >this message, will be the patches that add the drivers to the
> >drivers/staging/ tree, and a whole bunch of cleanups.
> >
> >It's taken a long road to get here, and I'd like to thank the following
> >people who made this possible:
> >  - Steve Hemminger for the initial prodding and extreme patience
> >  - Hank Janssen for providing the code and working with me to get it
> >    into a workable and semi-mergable state.  His involvement within
> >    Microsoft was also invaluable.
> >  - Sam Ramji for his push within Microsoft to make this happen in a
> >    manner that works with the Linux community.
> >  - Novell for sponsoring my work on the Linux Driver project, without
> >    which, this would not have even been possible.
> 
> (Your title as Maintainer of Crap has been well earned. But crap
> should not be maintained, it should be improved.)

Hey, we've been working on this, if you look at the .31 merge, we got
rid of more code than we added in the staging directory, and I have a
patch to remove another driver queued up to go to Linus before the final
.31 release as well.

So don't think it's just crap coming in and nothing coming out :)

> I took a random patch to look at
> (add-the-hyper-v-virtual-network-driver.patch to be precise). I think
> the /hv/ subdirectory name should be expanded a little (to, say,
> /hyper-v/); we're not in the Unix days anymore where space is at such
> a premium that people even strip the last e off /usr. Our wireless
> drivers also don't live in /wl/. And since hv does not seem to be
> related to a hypervisor — cf. sunhv.c.

Sure, names are just names, I don't really care about this, I just
picked 'hv' as it was easy to type...

> As for the code… I was immediately greeted by the screaming-uppercase
> typedef crap jungle that is so redundant[1] yet typical in many
> commercial products. One may hope that the evolution of the posted
> hyper-v code brings a coding strategy breeze into the house of
> Microsoft.
> 
> [1] DWORD they could have replaced by uint32_t once it became
> available via C99's stdint.h. The LPCSTR crap only makes sense if you
> are a lazy typist, but I would not call code doing things like LPCSTR
> clean. At least it's one thing - consistent. Consistently hard to
> read, though.

Look at the further patches in the series, I get rid of that typedef.

And yes, there's lots left to do, see the TODO file for details if you
are interested in helping out.

thanks,

greg k-h
