Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZFEICi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZFEICi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZFEICW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:02:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56631 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZFEICV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:02:21 -0400
Subject: Re: Intel 915GM MCHBAR bug
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: eric@anholt.net, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20090604112738.4c01d35e@jbarnes-x200>
References: <4A242C81.6020906@cs.helsinki.fi>
	 <20090604112738.4c01d35e@jbarnes-x200>
Date: Fri, 05 Jun 2009 11:02:21 +0300
Message-Id: <1244188941.23533.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

(I am cc'ing linux-kernel.)

On Mon, 01 Jun 2009 22:31:13 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Hi Jesse,
> > 
> > I am seeing this on my Eee PC 701 which is running a Ubuntu 
> > 2.6.28-11.42-generic stock kernel:
> > 
> > [   76.826966] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't
> > read from MCHBAR.  Disabling tiling.
> > [   76.827215] [drm] Initialized i915 1.6.0 20080730 on minor 0
> > [   76.834037] [drm:i915_setparam] *ERROR* unknown parameter 4
> > [   76.834104] [drm:i915_getparam] *ERROR* Unknown parameter 6
> > 
> > Google turned up this patch
> > 
> > http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html
> > 
> > but I don't seem to find it mainline kernel.
> > 
> > Was the bug fixed in some other way? It seem that distributions have
> > not yet picked up your patch and I am unsure if it's in any of the
> > -stable kernels.

On Thu, 2009-06-04 at 11:27 +0100, Jesse Barnes wrote:
> I think Eric acked it but may not have pushed it to drm-intel-next
> yet.  Should happen in the next week or two though as we prepare the
> merge window series.

OK, thanks for the info! FYI, I tested 2.6.30-rc8 with your patch
applied and everything works smoothly on my EeePC 701. I did not test
plain 2.6.30-rc8 as I expect it to show same kind of behavior as Ubuntu
distro kernel. Is this correct or do you want me to test 2.6.30-rc8 too?

I wonder why the patch hasn't received more attention as it's a pretty
critical bug. The _default_ Ubuntu 9.04 netbook remix installation is
completely broken for EeePC 701 (and probably others as well) without
the patch. And it's not as if I'm the only one that suffers from it. A
quick Google search reveals that a lot of people are hitting it.

So I really do think we need to merge this patch to the upcoming 2.6.31
ASAP and backport it to -stable after it has gotten some more testing.

			Pekka

