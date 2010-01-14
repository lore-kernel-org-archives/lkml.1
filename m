Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812Ab0ANCnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0ANCnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560Ab0ANCnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:43:22 -0500
Received: from kroah.org ([198.145.64.141]:37041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0ANCnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:43:22 -0500
Date: Wed, 13 Jan 2010 18:36:55 -0800
From: Greg KH <greg@kroah.com>
To: Scott Smedley <ss@aao.gov.au>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100114023655.GA25618@kroah.com>
References: <201001122242.22774.mitov@issp.bas.bg> <20100112235221.GA20761@aao.gov.au> <20100113001724.GB29904@kroah.com> <201001130816.43855.mitov@issp.bas.bg> <20100114010335.GB20569@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114010335.GB20569@aao.gov.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 12:03:36PM +1100, Scott Smedley wrote:
> Hi Greg & Marin,
> 
> > > Scott, any comparison between the two of them as to which one actually
> > > works better?
> 
> I'd be interested in Marin's opinion as he appears to have used both
> drivers extensively.
> 
> I'd like a userspace program to actually try out Marin's driver, but
> I can still make some general comments:
> 
> Things I like about Marin's driver:
> - It is only ~1/3rd the size. (by counting new lines)
> - The code is much neater.
> - It can acquire frames at 25 fps (real-time), according to Marin.
> - At least 1 person with intimate knowledge of the code seems keen to
>   maintain it.
> 
> Things I like about the sourceforge (SF) driver:
> - It works in CCIR mode (768x576) or 640x480 mode.
> - It is well tested.
> - It works with most kernel versions. ie. 2.2, 2.4, & 2.6. (mostly)
> - It works with multiple boards.
> - The code is moderately well commented.
> - It includes simple (user space) example programs.
> 
> 
> Clearly each driver has strengths over the other.
> 
> It would probably be easier to upgrade Marin's driver to match the
> strengths of the SF driver than the other way around. The only
> difficulty might be in making Marin's driver work with older kernel
> versions. IMO, that's probably an acceptable sacrifice to make. (For
> users of legacy systems, we could point them to the (unmaintained)
> driver on SF.)

We don't need to worry about older kernel versions from here on out.
That will make the one in the staging tree smaller as well, as the
compatibility code will soon be deleted.

So that leaves the functionality issues.   Is the only difference that
one can capture faster than the other?  They should be using the v4l
apis so userspace shouldn't be a difference either, right?

thanks,

greg k-h
