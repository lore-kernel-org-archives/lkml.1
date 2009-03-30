Return-Path: <linux-kernel-owner+w=401wt.eu-S1751044AbZC3HSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbZC3HSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZC3HSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:18:03 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:57334 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZC3HSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:18:01 -0400
Date: Mon, 30 Mar 2009 09:17:56 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: regression in 2.6.29-git3 on SH/Dreamcast
Message-ID: <20090330071755.GA30234@roarinelk.homelinux.net>
References: <1238353446.6471.14.camel@localhost.localdomain> <1238369758.6471.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238369758.6471.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, Mar 30, 2009 at 12:35:58AM +0100, Adrian McMenamin wrote:
> On Sun, 2009-03-29 at 20:04 +0100, Adrian McMenamin wrote:
> > While 2.6.29 boots cleanly on the Dreamcast, later revisions are likely
> > to crash with an OOM condition (this is a race, it doesn't happen on
> > every boot, but on about one in every three or four).
> > 
> 
> Still don't know why this timer patch is tipping the machine over, but I
> have found that if I set CONFIG_NO_HZ=y then the machine will boot with
> the patch applied.

I found that enabling swapfile support in Kconfig also reduces the frequency
of OOMs on my sh7760.   While I don't experience your particular problem, my
personal observation is that since around >2.6.22 linux-sh may OOM without
actual swapspace a lot sooner  (i.e. post 2.6.25 I can't even do "emerge -pv
world" without the kernel OOMing on me! This is with unreviewed platform code,
so take this info with a mountain of salt).

	Manuel Lauss
