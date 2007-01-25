Return-Path: <linux-kernel-owner+w=401wt.eu-S965566AbXAYWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbXAYWHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965567AbXAYWHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:07:39 -0500
Received: from mail.suse.de ([195.135.220.2]:54740 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965566AbXAYWHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:07:38 -0500
Date: Thu, 25 Jan 2007 14:06:31 -0800
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: gpu sharing layer for kernel
Message-ID: <20070125220631.GB5886@kroah.com>
References: <1169637623985-git-send-email-airlied@linux.ie> <20070124214654.GA30634@kroah.com> <21d7e9970701241439y1431254bwf088f9f3043dd0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970701241439y1431254bwf088f9f3043dd0c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 09:39:47AM +1100, Dave Airlie wrote:
> >> Why do we want this?
> >>
> >> Currently the kernel cannot provide both the fb and drm drivers with
> >> access to the device model and this means the drm cannot get any
> >> suspend/resume callbacks.  This layer attempts to fix this problem by
> >> adding a bus for the gpu drivers to attach to. Currently a lowlevel
> >> binding driver is needed along with optional fb and drm components.
> >
> >If we were to allow this kind of "sharing" for all PCI devices would
> >that work out instead?  Or would this layer still be needed?
> 
> Initially this layer wouldn't be needed, but I'd like to add some
> awareness to the drivers, so the drm can tell the fb to stop doing
> stuff and vice-versa if necessary....  but perhaps that could be done
> with a generic layer also.. or via the lowlevel driver I have...

Ok, I have no objection to this layer right now, as it solves your
problem, and while I would like some time in the future to add such a
layer for the PCI devices, it is no where on my todo plate just yet...

thanks,

greg k-h
