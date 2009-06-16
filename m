Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbZFPSuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbZFPSuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbZFPSuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:50:32 -0400
Received: from kroah.org ([198.145.64.141]:33991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbZFPSuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:50:32 -0400
Date: Tue, 16 Jun 2009 11:45:44 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
Message-ID: <20090616184544.GC28853@kroah.com>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie> <20090615022235.GA12905@kroah.com> <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:43:38PM +1000, Dave Airlie wrote:
> On Mon, Jun 15, 2009 at 12:22 PM, Greg KH<greg@kroah.com> wrote:
> > On Mon, Jun 15, 2009 at 03:08:56AM +0100, Dave Airlie wrote:
> >>
> >> Hi Linus,
> >>
> >> Please pull the 'drm-linus' branch from
> >> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> >>
> >> This is big. It contains the initial TTM memory manager + ATI radeon KMS
> >> support. Currently the KMS code is part of the DRM radeon driver however
> >> it is very clearly separated internally from the old codepaths. We've
> >> elected to keep the radeon KMS Kconfig build/enable under staging for now
> >> since we may have some ABI tweaks to sort out in this release cycle,
> >> however the code is all in the drm. I don't think this enables crap
> >> tainting, but at least no-one will find kms by accident.
> >
> > No, the module loader looks for stuff in drivers/staging/ to cause a
> > "taint".
> >
> > But why not just keep the Kconfig stuff in your own directory, and
> > depend on CONFIG_STAGING if you want to not have it show up for "normal"
> > users?  It seems odd to put anything in drivers/staging/Kconfig for
> > something that is not in drivers/staging.
> >
> > I'm guessing this Kconfig change was not in linux-next?  Or had it been
> > there and I just missed it somehow?
> >
> 
> No since I was on holidays until the just before the merge window
> opened, the patches
> did get posted to lkml but missed your cc.
> 
> Well we'd like to make sure people go via the staging menus to get at
> the kconfig option
> for now, granted it probably doesn't matter whether it goes in staging
> menus or in drm depends
> on CONFIG_STAGING. Up to you I can post a patch after this merge to
> move it to drm.

Ok, I'll defer to your judgement here.

thanks,

greg k-h
