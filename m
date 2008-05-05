Return-Path: <linux-kernel-owner+w=401wt.eu-S1763933AbYEETG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763933AbYEETG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763794AbYEETFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:05:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:18918 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbYEETE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,439,1204531200"; 
   d="scan'208";a="561011976"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: fb layer & ioremap_wc
Date: Mon, 5 May 2008 12:04:48 -0700
User-Agent: KMail/1.9.9
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
References: <200805022122.03576.elendil@planet.nl> <200805051045.31026.jesse.barnes@intel.com> <200805052059.01535.elendil@planet.nl>
In-Reply-To: <200805052059.01535.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051204.49135.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 11:59 am Frans Pop wrote:
> On Monday 05 May 2008, you wrote:
> > On Monday, May 05, 2008 10:32 am Frans Pop wrote:
> > > I suspect it could be vesafb/fbcon related instead. Normally I boot my
> > > system with 'quiet vga=791', i.e. with vesafb. I then see the
> > > artifacts.
> > >
> > > When I boot without 'vga=791', I hit another, unrelated regression
> > > (which I'll report separately) [1].
> > >
> > > When I boot with 'video=vfb:off', I do _not_ get the artifacts when X
> > > exits.
> >
> > Ahhh, I missed that part of your config.  That could definitely have an
> > effect on things...  You'll probably want something like the attached
>
> Not sure what to make of this.
> With your patch I still get the artifacts, but they are displayed a lot
> shorter. I get only a flash instead of a-2 seconds.

Hm, so I guess some other user is still using UC on the region.  [Note to fb 
list:  the patch just made vesafb use ioremap_wc instead of ioremap).

> > (there are other places in the fb layer that want similar treatment,
> > iirc, maybe fb_pgprotect?).
>
> Do you want to try a more complete review/patch or should this be punted
> over to the framebuffer folks?

Yeah, those bits have changed since I last looked at them, hopefully the fb 
guys can help.

Jesse
