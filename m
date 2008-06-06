Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbYFFGGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbYFFGGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYFFGG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:06:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:38672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbYFFGG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:06:28 -0400
Date: Thu, 5 Jun 2008 18:45:00 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: via agp patches
Message-ID: <20080606014500.GF3325@suse.de>
References: <20080531003214.GA6208@suse.de> <20080531003250.GB6208@suse.de> <20080531144715.GA22616@redhat.com> <20080531174113.GA18996@suse.de> <20080605174535.GA10361@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605174535.GA10361@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 01:45:35PM -0400, Dave Jones wrote:
> On Sat, May 31, 2008 at 10:41:13AM -0700, Greg KH wrote:
>  > On Sat, May 31, 2008 at 10:47:15AM -0400, Dave Jones wrote:
>  > > On Fri, May 30, 2008 at 05:32:50PM -0700, Greg KH wrote:
>  > >  > 
>  > >  > Looks like this adds a new device id, I have no idea why they remove
>  > >  > another one at the same time...
>  > > 
>  > > I sent a patch adding the missing ident to airlied a few weeks back.
>  > > I think it's currently in -mm.
>  > 
>  > Great.
>  > 
>  > > The removal of the other id is a mystery to me.
>  > 
>  > Here's what I got back from Via about this:
>  > 	VT3336 is a chipset for AMD Athlon/K8 CPU. Due to K8's unique
>  > 	architecture, the AGP resource and behavior are different from
>  > 	the traditional AGP which resides only in chipset. AGP is used
>  > 	by 3D driver which wasn't available for the VT3336 and VT3364
>  > 	generation until now.  Unfortunately, by testing, VT3364 works
>  > 	but VT3336 doesn't. That is why the subtraction. I think other
>  > 	options are leaving it in the AGP, but removing it from our DRI
>  > 	driver. Or, just leave it in both but warn people for issues in
>  > 	the release note.
>  > 
>  > 
>  > So it sounds like it would be good to remove that id.
> 
> Sounds plausible. This needs to go in the changelog.

I will put it there.

> A lot of their K8 chipsets were also used on P4 (I think they
> abstracted the architectural differences with V-Link), but
> if they claim this wasn't used on any of the P4 boards,
> I guess they would know better than us.

One would hope :)

thanks,

greg k-h
