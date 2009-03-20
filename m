Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZCTPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZCTPuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZCTPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:50:37 -0400
Received: from kroah.org ([198.145.64.141]:49123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753146AbZCTPuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:50:37 -0400
Date: Fri, 20 Mar 2009 08:50:10 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Stone <daniel@fooishbar.org>,
       Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090320155010.GA13556@kroah.com>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <20090319162719.GB32078@kroah.com> <20090320060823.GF32194@fooishbar.org> <20090320145340.GA11347@kroah.com> <20090320150032.31ef6a51@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320150032.31ef6a51@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 03:00:32PM +0000, Alan Cox wrote:
> > > By the same logic, would you support including the proprietary NVIDIA
> > > driver while we wait for Nouveau to catch up?
> > 
> > The license of the NVIDIA driver does not allow that to even be a
> > possibility.
> 
> I'm not convinced this is any different. If you accept the 3D changes you
> step into a dangerous world of estoppel and since it has many
> rightsholders also the wonderful world of contributory infringement. It
> really really needs lawyers to look into it.

I would hope that Intel's lawyers would have done such a thing before
releasing the kernel and xorg code under the licenses that they did :)

> Now the other way to do it that might be more productive and simpler
> would be to rip all the 3D crap out of that driver and just include the
> minimum needed 2D bits for the open source X driver. Makes the code
> smaller and cleaner, avoids an legal questions and lets people get on
> with real work.

Hm, that sounds fine to me.

Does that mean that all of these drm patches that I posted are _only_
needed for the 3d portions of the driver?  If I rip out the portions of
the psb kernel driver that need these changes, do I end up with an
working 2d driver as well?  Richard and Thomas, any thoughts here?

thanks,

greg k-h
