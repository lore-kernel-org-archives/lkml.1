Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbXLUUgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbXLUUgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbXLUUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:36:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34215 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXLUUgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:36:43 -0500
Date: Fri, 21 Dec 2007 12:35:26 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Tejun Heo <teheo@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Error returns not handled correctly by
	sysfs.c:subsys_attr_store()
Message-ID: <20071221203526.GA23767@kroah.com>
References: <1195683419.16019.225.camel@grinch> <20071126203116.0c93cdb9.akpm@linux-foundation.org> <20071127053321.GA975@kroah.com> <474D1BD4.2050805@suse.de> <1196278300.5431.9.camel@grinch> <474E10CF.7050009@suse.de> <1196716558.20124.179.camel@bluto.andrew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196716558.20124.179.camel@bluto.andrew>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 02:15:58PM -0700, Andrew Patterson wrote:
> On Thu, 2007-11-29 at 10:07 +0900, Tejun Heo wrote:
> > Andrew Patterson wrote:
> > > I tried with clean 2.6.24-rc3 and get the same bad behavior.  This is on
> > > an ia64 box, so maybe that is an issue. I can try on an x86 box as well.
> > > Oh, one other thing.  I tried a "uname -r" to make sure I had the
> > > correct kernel booted and got:
> > > 
> > > # uname -r
> > > 2.6.24-rc3
> > > x
> > > y
> > > z
> > > #
> > 
> > Yeah, please try it on another machine from clean tree.  sysfs code is
> > definitely not endian dependent and is 64 bit clean.  Heck, all my test
> > machines run 64 bit these days.  I would be surprised if it's something
> > architecture dependent but please try on a different machine with
> > different userland with kernel built from fresh source tree.
> > 
> > Thanks.
> 
> I tried this on a AMD system running an i386 kernel. I get the same bad
> behavior.  This is from a 2.6.24-rc3 kernel downloaded from kernel.org.
> I ran "make mrproper" followed by "make oldconfig" and accepted all the
> defaults for the config.
> 
> There is one slight change with this experiment.  Other nodes are not
> getting corrupted, i.e., uname -r is getting the correct value.

Are you still seeing this on 2.6.24-rc6?

I still can not duplicate this here :(

thanks,

greg k-h
