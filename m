Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZIQMga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZIQMga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZIQMg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:36:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZIQMg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:36:29 -0400
Date: Thu, 17 Sep 2009 14:36:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917123627.GP18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <20090917121232.GA5041@osiris.boeblingen.de.ibm.com> <1253189782.4975.51.camel@penberg-laptop> <20090917122141.GB5041@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917122141.GB5041@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:21:41PM +0200, Heiko Carstens wrote:
> On Thu, Sep 17, 2009 at 03:16:21PM +0300, Pekka Enberg wrote:
> > On Thu, 2009-09-17 at 14:12 +0200, Heiko Carstens wrote:
> > > Ok, I just wanted to debug this on s390. But... the bug seems to have
> > > disappeared.
> > > I pulled in
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slqb/core
> > > 
> > > and tried defconfig (+SLQB) as well as allyesconfig (+SLQB). Both started and
> > > didn't show the crash-before-console-is-active which went away when switching
> > > to a different allocator.
> > > So the s390 restriction seems to be resolved. Don't know why...
> > 
> > IIRC, this is the only bug fix that was merged after your report:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=ff61c4950125b09b5e5a83d48a6c81827e9d67ab
> 
> Still works even if I revert that patch. Probably something else interfered.

Nasty. I don't suppose it would be too much work to try bisecting it?
Unfortunately with this kind of thing, bisecting doesn't always point
to anything meaningful anyway :(
