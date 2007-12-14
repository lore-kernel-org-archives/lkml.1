Return-Path: <linux-kernel-owner+w=401wt.eu-S935438AbXLNWns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438AbXLNWns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935224AbXLNWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:42:00 -0500
Received: from mx1.suse.de ([195.135.220.2]:56930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934890AbXLNWl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:41:59 -0500
Date: Fri, 14 Dec 2007 14:24:58 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Add Documentation for FAIR_USER_SCHED sysfs files
Message-ID: <20071214222458.GD29375@suse.de>
References: <20071212023836.GB1486@linux.vnet.ibm.com> <20071212053556.GA25334@suse.de> <20071212054859.GC1486@linux.vnet.ibm.com> <20071212095843.GB24246@elte.hu> <20071212101645.GA30004@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212101645.GA30004@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 11:16:45AM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > 
> > > > Hm, how about describing the units here?  Can you put "10" in each 
> > > > file and everyone will get the same share?  100?  1?  1024 seems 
> > > > like an odd "share" number.  Unless there is some other document you 
> > > > wish to refer people to do help describe these values?
> > > 
> > > It is proportional. That is, if two users have same value for shares, 
> > > they will get equal bandwidth on the CPU. If they are in the ratio 
> > > 1:2, then they will share it in that ratio. I've updated the patch for 
> > > this. Hope it is clearer.
> > 
> > thanks, applied.
> 
> unless Greg wants to push this via the sysfs git tree?

Sure, I can do that, what's one more patch in my tree?  :)

thanks,

greg k-h
