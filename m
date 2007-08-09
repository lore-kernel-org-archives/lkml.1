Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXHIWWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXHIWWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXHIWWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:22:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXHIWWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:22:22 -0400
Date: Thu, 9 Aug 2007 15:24:27 -0700
From: Greg KH <gregkh@suse.de>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-ID: <20070809222427.GA32127@suse.de>
References: <20070723145105.GK26212@stusta.de> <20070809145140.654303a0.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809145140.654303a0.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 02:51:40PM -0700, Kristen Carlson Accardi wrote:
> On Mon, 23 Jul 2007 16:51:05 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > If !mem_node we did already return -ENOMEM above in the function.
> > 
> > Spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Greg - you are listed as the maintainer for this driver.

Not anymore, look at 2.6.23-rc1 :)

> Can you either
> point me to someone who can review this patch or review it yourself?  
> Looking at the code, it looks like it's possible that the driver writer
> wanted this code patch to be able to be taken if it got IO resources
> and not MEM resources, and if they didn't there's other cleanups that
> should be done for the no iomem case.

Hm, I agree that this looks like the way the code was intended to work,
but as this code has been working just fine so far the way it is, I'm
not inclined to change it much, if any.

Especially as I no longer even have the hardware to test it on :(

So, how about we just leave it alone?

thanks,

greg k-h
