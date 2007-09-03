Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbXICKEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbXICKEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXICKDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:03:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXICKDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:03:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1: boot failure on HPC nx6325
Date: Mon, 3 Sep 2007 12:15:06 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <200709022239.14175.rjw@sisk.pl> <1188808600.5698.9.camel@chaos>
In-Reply-To: <1188808600.5698.9.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031215.06824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 September 2007 10:36, Thomas Gleixner wrote:
> On Sun, 2007-09-02 at 22:39 +0200, Rafael J. Wysocki wrote:
> > On Saturday, 1 September 2007 06:58, Andrew Morton wrote:
> > > - dynticks-for-x86_64 has returned
> > 
> > It fails to boot on my HPC nx6325 (hangs very early, before any messages reach
> > the console), because of this patch:
> > 
> > x86_64-convert-to-clockevents.patch
> 
> Sigh. Can you try
> 
> noapictimer
> nohpet
> 
> on the kernel commandline please ?

nohpet is sufficient to make it work.

> Also it would be interesting whether the -hrt patchset on top of rc5 has
> the same problem:
> 
> http://www.tglx.de/projects/hrtimers/2.6.23-rc5/patch-2.6.23-rc5-hrt1.patches.tar.bz2

I'll try that later.

Greetings,
Rafael
