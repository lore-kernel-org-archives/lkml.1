Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYHJTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYHJTSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 15:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYHJTSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 15:18:35 -0400
Received: from the.earth.li ([217.147.81.2]:51956 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbYHJTSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 15:18:34 -0400
Date: Sun, 10 Aug 2008 16:18:24 -0300
From: Jonathan McDowell <noodles@earth.li>
To: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <2@pervalidus.net>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
Message-ID: <20080810191823.GB4977@earth.li>
References: <20080725094334.GC30002@earth.li> <alpine.DEB.0.82.0807251107400.30593@skynet.skynet.ie> <20080801160256.GV30002@earth.li> <alpine.LNX.1.10.0808090541320.4876@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0808090541320.4876@pervalidus>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 05:47:42AM -0300, Frédéric L. W. Meunier wrote:
> On Fri, 1 Aug 2008, Jonathan McDowell wrote:
> >On Fri, Jul 25, 2008 at 11:10:07AM +0100, Dave Airlie wrote:
> >>>I've started to see "hangs" with X on an ATI RS690 with a 2.6.26 kernel.
> >>>The symptoms are that load average goes up, X stops accepting keypresses
> >>>or mouse clicks, but the cursor still moves around the screen in
> >>>response to the mouse being moved. I can't switch to a VT but can ssh in
> >>>remotely to see that things are still running. I don't seem to be able
> >>>to kill X but "shutdown -r now" cleanly reboots.
> >>>
> >>>radeon driver is recent git - 1c5858484da4fb1c9bc3ac3b4d7a97863ab99730
> >>>but I've seen it with older revisions too.
> >>>
> >>>It can take a couple of days for me to hit the problem, so a git bisect
> >>>could be a lengthy process. If anyone has any suggestions about faster
> >>>ways to track down the issue I'd like to hear them.
> >>
> >>git log v2.6.25..v2.6.26 drivers/char/drm
> >>
> >>5e35eff13f7dd0f5c1d82b3b4708b2f7a5f44113
> >>5cfb6956073a9e42d44a26790b7800980634d037
> >
> >No joy.
> >
> >>d396db321bcaec54345e7e9e87cea8482d6ae3a8
> >
> >I thought this might be it; nearly 5 days of uptime rather than the
> >usual less than 2. But I got the same symptoms today so I'll continue
> >working down the list.
> >
> >>259434acccbc823ee8bc00b2d2689ccccd25e1fd
> >>d7463eb41d88a39de2653fd41857c4ccddb8707b
> >>45e519052e8f583a709edd442a23f59581d3fe42
> >>2735977b12cb0f113aae24afff04747b6d0f5bf1
> >>3722bfc607d46275369865c02fe8694486d640b5
> >>fa0d71b967506031f7cb08ced6095d1c4f988594
> >>9f18409ea3d778a171a9505c0a849d846f352bd0
> 
> Any joy ?

259434acccbc823ee8bc00b2d2689ccccd25e1fd
d7463eb41d88a39de2653fd41857c4ccddb8707b
45e519052e8f583a709edd442a23f59581d3fe42

all don't seem to be the problem. It's getting harder to do the reverts
and I'm away this week so I haven't got any further yet.

> I apparently have the same problem with my RS690. I noticed it after
> upgrading from 2.6.25 to 2.6.26, alongside xorg-server (1.4.99.904 to
> 1.4.99.905) and Mesa (7.1-rc1 to 7.1-rc3). The ATI driver is 6.9.0.
> 
> Here it always freezes in a few minutes or less than an hour.  When it
> happens, I'm not running any 3D application and the CPU is idle. I may
> be just typing something in a shell. But it works disabling DRI.

Likewise, I'm not doing anything 3D related (at least, not consciously).

J.

-- 
] http://www.earth.li/~noodles/ []  No program done by a hacker will   [
]  PGP/GPG Key @ the.earth.li   []  work unless he is on the system.   [
] via keyserver, web or email.  []                                     [
] RSA: 4DC4E7FD / DSA: 5B430367 []                                     [
