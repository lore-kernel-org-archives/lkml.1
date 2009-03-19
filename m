Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZCSKn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZCSKn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZCSKnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:43:49 -0400
Received: from mga06.intel.com ([134.134.136.21]:34212 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754522AbZCSKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,388,1233561600"; 
   d="scan'208";a="499059249"
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core 
	changes
From: Richard Purdie <rpurdie@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>
In-Reply-To: <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
References: <20090319040809.GA29249@kroah.com>
	 <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 10:43:57 +0000
Message-Id: <1237459437.5359.50.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-03-19 at 16:48 +1000, Dave Airlie wrote:
> First off, the non-staging patches need more complete changelog entries,
> a bit of meaning goes a long way. I'll ack them if they are documented and
> make sense. The unlocked ioctl hook makes sense to me at least!
>
> Now the non-core DRM driver comes with some caveats no one mentioned,
> only the userspace 2D is open, no userspace 3D is available and I've no idea if
> one is forthcoming. Now I don't know enough about the Poulsbo to say this
> drm implementation is secure and can't DMA over my password file.

I think Thomas has covered these things and between us, we can improve
the patch series.

> There is no upstream X.org driver available for this yet, Ubuntu
> shipped something
> but really we should be at least seeing X.org and Mesa commitments from Intel
> to supporting this code in the future before we go shipping it all in
> the kernel.

An older version of the X.org driver has been available (with various
urls) at http://git.moblin.org/cgit.cgi/deprecated/xf86-video-psb/ for a
while. I'm working on getting this updated and that should happen soon.

I'm also working on getting the binary bits for 3D support publicly
available somewhere but these are not open source and unlikely to be any
time soon. We know this sucks, we're working on it but thats all I can
really say.

As Greg said, we don't envisage this driver being the final solution.
There is hardware out there, running Linux which needs any driver rather
than no driver now. Having a standard implementation that everyone uses
has to be preferable to everyone rolling their own modified version of
it. For 2D, the driver is open and people can chose to use the 3D
binaries or not. This would seem to fit the staging tree's mandate where
this driver could live until things get sorted properly.

Does this ease some of your concerns? I don't claim this is an ideal
situation but we're all trying to make the best of what we've got...

Cheers,

Richard



