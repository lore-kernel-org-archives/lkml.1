Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZFOC15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZFOC15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZFOC1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:27:48 -0400
Received: from kroah.org ([198.145.64.141]:47003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZFOC1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:27:48 -0400
Date: Sun, 14 Jun 2009 19:22:35 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
Message-ID: <20090615022235.GA12905@kroah.com>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:08:56AM +0100, Dave Airlie wrote:
> 
> Hi Linus,
> 
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> 
> This is big. It contains the initial TTM memory manager + ATI radeon KMS 
> support. Currently the KMS code is part of the DRM radeon driver however 
> it is very clearly separated internally from the old codepaths. We've 
> elected to keep the radeon KMS Kconfig build/enable under staging for now 
> since we may have some ABI tweaks to sort out in this release cycle, 
> however the code is all in the drm. I don't think this enables crap 
> tainting, but at least no-one will find kms by accident.

No, the module loader looks for stuff in drivers/staging/ to cause a
"taint".

But why not just keep the Kconfig stuff in your own directory, and
depend on CONFIG_STAGING if you want to not have it show up for "normal"
users?  It seems odd to put anything in drivers/staging/Kconfig for
something that is not in drivers/staging.

I'm guessing this Kconfig change was not in linux-next?  Or had it been
there and I just missed it somehow?

thanks,

greg k-h
