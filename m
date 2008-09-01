Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYIAC4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYIAC4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 22:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYIAC4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 22:56:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYIAC4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 22:56:47 -0400
Date: Sun, 31 Aug 2008 19:54:28 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jason Uhlenkott <juhlenko@akamai.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] remove the broken i82443bxgx_edac driver
Message-ID: <20080901025428.GD20359@kroah.com>
References: <20080831161011.GD3695@cs181140183.pp.htv.fi> <20080831180731.GA19695@juhlenko-desk.sanmateo.corp.akamai.com> <20080831210206.GK3695@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831210206.GK3695@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 12:02:06AM +0300, Adrian Bunk wrote:
> On Sun, Aug 31, 2008 at 11:07:31AM -0700, Jason Uhlenkott wrote:
> > On Sun, Aug 31, 2008 at 19:10:11 +0300, Adrian Bunk wrote:
> > > The i82443bxgx_edac driver was added more than one year ago, but after 
> > > only 3 seconds in Linus' tree it got a dependency on BROKEN with Andrew 
> > > stating:
> > > 
> > >     It will claim the PCI devices from under intel_agp.ko's feet.
> > >     Greg is brewing some fix for that.
> > > 
> > > Since noone seems to care enough about this driver to get it working we 
> > > can as well remove it.
> > 
> > This driver does work as long as it's not used concurrently with
> > intel-agp, and I know of at least one user of it (who has been locally
> > diking out the dependency on BROKEN).
> 
> With the dependency on BROKEN it might stay at having one user...
> 
> Is anyone going to fix it proerly?

Yes, I have patches in my private tree to get multiple drivers to
devices working.  Unfortunatly they also currently cause the machine to
crash in wierd ways, so they aren't quite there yet :)

I'll be working on them with other kernel developers in a week at a SuSE
Labs conference so we should be able to pound something out pretty soon.

thanks,

greg k-h
