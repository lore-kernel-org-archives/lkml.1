Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483Ab0ANDkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0ANDkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137Ab0ANDks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:40:48 -0500
Received: from kroah.org ([198.145.64.141]:59520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0ANDkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:40:47 -0500
Date: Wed, 13 Jan 2010 19:40:55 -0800
From: Greg KH <greg@kroah.com>
To: Scott Smedley <ss@aao.gov.au>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100114034055.GA27311@kroah.com>
References: <201001122242.22774.mitov@issp.bas.bg> <20100112235221.GA20761@aao.gov.au> <20100113001724.GB29904@kroah.com> <201001130816.43855.mitov@issp.bas.bg> <20100114010335.GB20569@aao.gov.au> <20100114023655.GA25618@kroah.com> <20100114031345.GA22542@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114031345.GA22542@aao.gov.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 02:13:45PM +1100, Scott Smedley wrote:
> Hi Greg,
> 
> > We don't need to worry about older kernel versions from here on out.
> 
> Ok.
> 
> > So that leaves the functionality issues.   Is the only difference that
> > one can capture faster than the other?
> 
> As mentioned, Marin's driver only supports CCIR mode & it
> hasn't been tested with multiple boards.

Ah, ok.

> >  They should be using the v4l
> > apis so userspace shouldn't be a difference either, right?
> 
> No. They are both standalone drivers. If we want V4L2 compatibility
> we would have to modify (either) driver significantly.

Well, that will be the requirement to get it merged into the main
portion of the kernel tree.  No special interfaces are allowed, sorry.

Anyway, I suggest the two of you decide on a plan forward.

thanks,

greg k-h
