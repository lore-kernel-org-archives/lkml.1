Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYHaVDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYHaVDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 17:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbYHaVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 17:03:21 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59043 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757784AbYHaVDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 17:03:20 -0400
Date: Mon, 1 Sep 2008 00:02:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jason Uhlenkott <juhlenko@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, Greg KH <greg@kroah.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] remove the broken i82443bxgx_edac driver
Message-ID: <20080831210206.GK3695@cs181140183.pp.htv.fi>
References: <20080831161011.GD3695@cs181140183.pp.htv.fi> <20080831180731.GA19695@juhlenko-desk.sanmateo.corp.akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080831180731.GA19695@juhlenko-desk.sanmateo.corp.akamai.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 11:07:31AM -0700, Jason Uhlenkott wrote:
> On Sun, Aug 31, 2008 at 19:10:11 +0300, Adrian Bunk wrote:
> > The i82443bxgx_edac driver was added more than one year ago, but after 
> > only 3 seconds in Linus' tree it got a dependency on BROKEN with Andrew 
> > stating:
> > 
> >     It will claim the PCI devices from under intel_agp.ko's feet.
> >     Greg is brewing some fix for that.
> > 
> > Since noone seems to care enough about this driver to get it working we 
> > can as well remove it.
> 
> This driver does work as long as it's not used concurrently with
> intel-agp, and I know of at least one user of it (who has been locally
> diking out the dependency on BROKEN).

With the dependency on BROKEN it might stay at having one user...

Is anyone going to fix it proerly?

Or should we work around the problem with a dependency on AGP_INTEL=n?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

