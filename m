Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbXLNQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbXLNQxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXLNQxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:53:40 -0500
Received: from mail.suse.de ([195.135.220.2]:34268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXLNQxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:53:39 -0500
Date: Fri, 14 Dec 2007 08:26:42 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, vincent.fortier1@ec.gc.ca,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071214162642.GA13898@suse.de>
References: <1197554397.19869.3.camel@lov.site> <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca> <1197562981.19869.5.camel@lov.site> <20071213165059.GC4865@elte.hu> <1197565842.19869.11.camel@lov.site> <20071213202125.GA25130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213202125.GA25130@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:21:26PM +0100, Ingo Molnar wrote:
> 
> * Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > > > > This one also fails to apply properly at the exact same place 
> > > > > has Ingo's previously posted patch.  Would need to backport his 
> > > > > one.
> > > > 
> > > > It depends on a completely reworked sysfs logic, I don't think it 
> > > > makes any sense to backport that.
> > > 
> > > well, if it fixes a live bug in a still supported stable kernel 
> > > release...
> > > 
> > > Vincent, could you try to just get rid of all actual uses of 
> > > se->attr.owner, within fs/sysfs/*.c? Something like the patch below. 
> > > (totally untested - might be fatally broken as well)
> > 
> > How can you think that this is not needed? You can not remove it with 
> > sysfs you are patching. Hope this explains it: 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0ab66088c855eca68513bdd7442a426c4b374ced
> 
> yeah - as i said it might be fatally broken (in fact it is). Do we 
> understand why Vincent got the crashes with vanilla 2.6.22.14 ?

No, and I can't seem to duplicate them here at all.

Does anyone have a test case for this that I can work on trying to
duplicate?

thanks,

greg k-h
