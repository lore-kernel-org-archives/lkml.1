Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXHIWuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXHIWuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXHIWtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:49:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:19864 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbXHIWty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,243,1183359600"; 
   d="scan'208";a="115694801"
Date: Thu, 9 Aug 2007 15:47:02 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-Id: <20070809154702.caa67a61.kristen.c.accardi@intel.com>
In-Reply-To: <20070809222427.GA32127@suse.de>
References: <20070723145105.GK26212@stusta.de>
	<20070809145140.654303a0.kristen.c.accardi@intel.com>
	<20070809222427.GA32127@suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 15:24:27 -0700
Greg KH <gregkh@suse.de> wrote:
pcihpd-discuss@lists.sourceforge.net
> On Thu, Aug 09, 2007 at 02:51:40PM -0700, Kristen Carlson Accardi wrote:
> > On Mon, 23 Jul 2007 16:51:05 +0200
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > If !mem_node we did already return -ENOMEM above in the function.
> > > 
> > > Spotted by the Coverity checker.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > Greg - you are listed as the maintainer for this driver.
> 
> Not anymore, look at 2.6.23-rc1 :)
> 
> > Can you either
> > point me to someone who can review this patch or review it yourself?  
> > Looking at the code, it looks like it's possible that the driver writer
> > wanted this code patch to be able to be taken if it got IO resources
> > and not MEM resources, and if they didn't there's other cleanups that
> > should be done for the no iomem case.
> 
> Hm, I agree that this looks like the way the code was intended to work,
> but as this code has been working just fine so far the way it is, I'm
> not inclined to change it much, if any.
> 
> Especially as I no longer even have the hardware to test it on :(
> 
> So, how about we just leave it alone?
> 
> thanks,
> 
> greg k-h
> 

fine by me - let's NAK this patch (and all future ones for this driver) until 
someone with hardware steps up to maintain this driver.  Eventually it
will just die I guess.
