Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZC3XhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZC3XhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZC3XhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:37:08 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43756 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3XhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:37:07 -0400
Date: Tue, 31 Mar 2009 08:32:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: regression in 2.6.29-git3 on SH/Dreamcast
Message-ID: <20090330233233.GJ19535@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Manuel Lauss <mano@roarinelk.homelinux.net>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1238353446.6471.14.camel@localhost.localdomain> <1238369758.6471.16.camel@localhost.localdomain> <20090330071755.GA30234@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330071755.GA30234@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 09:17:56AM +0200, Manuel Lauss wrote:
> Hi Adrian,
> 
> On Mon, Mar 30, 2009 at 12:35:58AM +0100, Adrian McMenamin wrote:
> > On Sun, 2009-03-29 at 20:04 +0100, Adrian McMenamin wrote:
> > > While 2.6.29 boots cleanly on the Dreamcast, later revisions are likely
> > > to crash with an OOM condition (this is a race, it doesn't happen on
> > > every boot, but on about one in every three or four).
> > > 
> > 
> > Still don't know why this timer patch is tipping the machine over, but I
> > have found that if I set CONFIG_NO_HZ=y then the machine will boot with
> > the patch applied.
> 
> I found that enabling swapfile support in Kconfig also reduces the frequency
> of OOMs on my sh7760.   While I don't experience your particular problem, my
> personal observation is that since around >2.6.22 linux-sh may OOM without
> actual swapspace a lot sooner  (i.e. post 2.6.25 I can't even do "emerge -pv
> world" without the kernel OOMing on me! This is with unreviewed platform code,
> so take this info with a mountain of salt).
> 
On a board with how much memory? What SLAB allocator are you using? This
is the first I have heard about any such issues, and if our memory
consumption drastically went up somewhere it would have been nice to know
when this became a problem. The Dreamcast is fixed at 16MB, and the
system in general is close to being OOM before it even makes it all the
way up. It would also be helpful to see the numbers with SLOB, which
should by the default on all of these systems.
