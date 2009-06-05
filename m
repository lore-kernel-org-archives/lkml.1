Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZFEUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZFEUBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZFEUBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:01:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbZFEUBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:01:40 -0400
Date: Fri, 5 Jun 2009 13:00:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: jbarnes@virtuousgeek.org, eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Re: Intel 915GM MCHBAR bug
Message-Id: <20090605130033.5ff3d0b5.akpm@linux-foundation.org>
In-Reply-To: <1244188941.23533.16.camel@penberg-laptop>
References: <4A242C81.6020906@cs.helsinki.fi>
	<20090604112738.4c01d35e@jbarnes-x200>
	<1244188941.23533.16.camel@penberg-laptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 11:02:21 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Jesse,
> 
> (I am cc'ing linux-kernel.)
> 
> On Mon, 01 Jun 2009 22:31:13 +0300
> > Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> > > Hi Jesse,
> > > 
> > > I am seeing this on my Eee PC 701 which is running a Ubuntu 
> > > 2.6.28-11.42-generic stock kernel:
> > > 
> > > [   76.826966] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't
> > > read from MCHBAR.  Disabling tiling.
> > > [   76.827215] [drm] Initialized i915 1.6.0 20080730 on minor 0
> > > [   76.834037] [drm:i915_setparam] *ERROR* unknown parameter 4
> > > [   76.834104] [drm:i915_getparam] *ERROR* Unknown parameter 6
> > > 
> > > Google turned up this patch
> > > 
> > > http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html
> > > 
> > > but I don't seem to find it mainline kernel.
> > > 
> > > Was the bug fixed in some other way? It seem that distributions have
> > > not yet picked up your patch and I am unsure if it's in any of the
> > > -stable kernels.
> 
> On Thu, 2009-06-04 at 11:27 +0100, Jesse Barnes wrote:
> > I think Eric acked it but may not have pushed it to drm-intel-next
> > yet.  Should happen in the next week or two though as we prepare the
> > merge window series.
> 
> OK, thanks for the info! FYI, I tested 2.6.30-rc8 with your patch
> applied and everything works smoothly on my EeePC 701. I did not test
> plain 2.6.30-rc8 as I expect it to show same kind of behavior as Ubuntu
> distro kernel. Is this correct or do you want me to test 2.6.30-rc8 too?
> 
> I wonder why the patch hasn't received more attention as it's a pretty
> critical bug. The _default_ Ubuntu 9.04 netbook remix installation is
> completely broken for EeePC 701 (and probably others as well) without
> the patch. And it's not as if I'm the only one that suffers from it. A
> quick Google search reveals that a lot of people are hitting it.
> 
> So I really do think we need to merge this patch to the upcoming 2.6.31
> ASAP and backport it to -stable after it has gotten some more testing.
> 

Wanna show us the patch?

Because the world could certainly do with more i915 bugfixes :(
