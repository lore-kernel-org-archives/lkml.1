Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbYFMQmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbYFMQmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbYFMQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:42:23 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:43928 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758749AbYFMQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:42:21 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: fb layer & ioremap_wc
Date: Fri, 13 Jun 2008 18:42:15 +0200
User-Agent: KMail/1.9.9
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
References: <200805022122.03576.elendil@planet.nl> <200805052059.01535.elendil@planet.nl> <200805051204.49135.jesse.barnes@intel.com>
In-Reply-To: <200805051204.49135.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131842.16619.elendil@planet.nl>
X-OriginalArrivalTime: 13 Jun 2008 16:42:19.0129 (UTC) FILETIME=[71EC9690:01C8CD74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, Jesse Barnes wrote:
> On Monday, May 05, 2008 11:59 am Frans Pop wrote:
> > On Monday 05 May 2008, you wrote:
> > > On Monday, May 05, 2008 10:32 am Frans Pop wrote:
> > > > I suspect it could be vesafb/fbcon related instead. Normally I
> > > > boot my system with 'quiet vga=791', i.e. with vesafb. I then see
> > > > the artifacts.
> > > >
> > > > When I boot with 'video=vfb:off', I do _not_ get the artifacts
> > > > when X exits.
> > >
> > > Ahhh, I missed that part of your config.  That could definitely
> > > have an effect on things...  You'll probably want something like
> > > the attached
> >
> > Not sure what to make of this.
> > With your patch I still get the artifacts, but they are displayed a
> > lot shorter. I get only a flash instead of a-2 seconds.
>
> Hm, so I guess some other user is still using UC on the region.  [Note
> to fb list:  the patch just made vesafb use ioremap_wc instead of
> ioremap).

AFAIK there has been no progress on this issue, which is now listed on the 
regression list for .26 [1]. As there has been no response from any fb 
devs, is someone else maybe willing to have a closer look at this?

I'm still seeing the artifacts with -rc6 and the severity seems to depend 
on what was last displayed: sometimes the whole display is covered with 
colored nonsense, artistic maybe but not desired...

Cheers,
FJP

[1] http://bugzilla.kernel.org/show_bug.cgi?id=10843
