Return-Path: <linux-kernel-owner+w=401wt.eu-S1765573AbYBMGCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765573AbYBMGCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764948AbYBMGCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:02:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60054 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764712AbYBMGCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:02:07 -0500
Date: Tue, 12 Feb 2008 20:43:04 -0800
From: Greg KH <greg@kroah.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: bzolnier@gmail.com, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: "ide=reverse" do we still need this?
Message-ID: <20080213044304.GA10101@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213024329.GA6912@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213024329.GA6912@deepthought>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:43:29AM +0000, Ken Moffat wrote:
> On Tue, Feb 12, 2008 at 04:15:07PM -0800, Greg KH wrote:
> > 
> > I'm curious if we really still support the ide=reverse option?  It's a
> > config option that I don't think the distros still enable (SuSE does
> > not).  Is this still needed these days?
> > 
>  My "server" has a consumer-grade desktop amd64 mobo, with all that
> implies about cheap hardware and strange/misleading bios options.
> It also has an add-in dual IDE card with the main data on raid1.
> It's set to ide=reverse, without that it doesn't boot (the add-ins
> are IDE, system drive is SATA, so I guess it probably tries to boot
> from the DVD - it's been a long time since it bit me and I don't
> remember the full details.
> 
>  That was how it was set for 2.6.18.6, and how it now boots from
> 2.6.22.18.  I think at one time the order of the interfaces might
> have been different.  Certainly, I carry forward a fallback without
> ide=reverse in lilo.conf, just in case the disks move on my next
> kernel upgrade.

Can't you just boot with /dev/disk/by-id/ and an initramfs to not have
to worry about such a thing in the future?

Have you tried the PATA drivers instead of IDE to see if this solves the
"moves around" issue?  If they work, then you would not need the command
line option at all.

thanks,

greg k-h
