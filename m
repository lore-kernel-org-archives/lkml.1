Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYGYKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYGYKK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYGYKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:10:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48011 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYGYKKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:10:14 -0400
Date: Fri, 25 Jul 2008 11:10:07 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jonathan McDowell <noodles@earth.li>
cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
In-Reply-To: <20080725094334.GC30002@earth.li>
Message-ID: <alpine.DEB.0.82.0807251107400.30593@skynet.skynet.ie>
References: <20080725094334.GC30002@earth.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've started to see "hangs" with X on an ATI RS690 with a 2.6.26 kernel.
> The symptoms are that load average goes up, X stops accepting keypresses
> or mouse clicks, but the cursor still moves around the screen in
> response to the mouse being moved. I can't switch to a VT but can ssh in
> remotely to see that things are still running. I don't seem to be able
> to kill X but "shutdown -r now" cleanly reboots.
> 
> radeon driver is recent git - 1c5858484da4fb1c9bc3ac3b4d7a97863ab99730
> but I've seen it with older revisions too.
> 
> It can take a couple of days for me to hit the problem, so a git bisect
> could be a lengthy process. If anyone has any suggestions about faster
> ways to track down the issue I'd like to hear them.

git log v2.6.25..v2.6.26 drivers/char/drm

5e35eff13f7dd0f5c1d82b3b4708b2f7a5f44113
5cfb6956073a9e42d44a26790b7800980634d037
d396db321bcaec54345e7e9e87cea8482d6ae3a8
259434acccbc823ee8bc00b2d2689ccccd25e1fd
d7463eb41d88a39de2653fd41857c4ccddb8707b
45e519052e8f583a709edd442a23f59581d3fe42
2735977b12cb0f113aae24afff04747b6d0f5bf1
3722bfc607d46275369865c02fe8694486d640b5
fa0d71b967506031f7cb08ced6095d1c4f988594
9f18409ea3d778a171a9505c0a849d846f352bd0

not sure if you wanna try reverting some of those and seeing which is the 
cause maybe..

Dave.

