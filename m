Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbXEVTjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbXEVTjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXEVTjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:39:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44910 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXEVTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:39:38 -0400
Date: Tue, 22 May 2007 12:36:45 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522193645.GB885@kroah.com>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <20070522185353.GE12157@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522185353.GE12157@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 02:53:53PM -0400, Dave Jones wrote:
> On Tue, May 22, 2007 at 11:47:33AM -0700, Greg Kroah-Hartman wrote:
>  > On Tue, May 22, 2007 at 02:14:44PM -0400, Chuck Ebbert wrote:
>  > > I'd like to propose we allow adding new device IDs as part
>  > > of the -stable process, but only under certain conditions:
>  > 
>  > Who would be the primary benifactor of this?
>  > 
>  > The very large majority of users out there use a distro kernel, and they
>  > provide the ids whenever possible as patches to their kernels, _or_ as a
>  > config option at startup that adds the ids to the drivers through sysfs.
> 
> It does mean however that there's lots of duplicated work between
> distros as everyone adds these patches anyway.

But distros don't all standardize on the same -stable release anyway, so
I don't see how a large ammount of duplicated work happens here.

>  > What's wrong with the current sysfs way of adding new device ids without
>  > touching the kernel?
> 
> sure, that works in some cases, but for others (quirks etc) it obviously doesn't.

I totally agree, and have never objected to quirk additions in the past.

thanks,

greg k-h
