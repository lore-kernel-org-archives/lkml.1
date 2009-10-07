Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZJGXj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZJGXj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZJGXj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:39:56 -0400
Received: from kroah.org ([198.145.64.141]:37322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774AbZJGXjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:39:55 -0400
Date: Wed, 7 Oct 2009 16:36:40 -0700
From: Greg KH <greg@kroah.com>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Matthias Hopf <mhopf@suse.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Samsung Backlight Patch
Message-ID: <20091007233640.GA8464@kroah.com>
References: <f3f71ab90910071414n482eca2dm18108c79ee08028d@mail.gmail.com>
 <20091007211916.GA4217@kroah.com>
 <f3f71ab90910071431g524fa807ib67f5fcfef7c70d1@mail.gmail.com>
 <20091007225828.GA7892@kroah.com>
 <f3f71ab90910071631g2ffb4796u6a3a370252c4cf92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3f71ab90910071631g2ffb4796u6a3a370252c4cf92@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 12:31:51AM +0100, Mike Lothian wrote:
> 2009/10/7 Greg KH <greg@kroah.com>:
> > On Wed, Oct 07, 2009 at 10:31:44PM +0100, Mike Lothian wrote:
> >> 2009/10/7 Greg KH <greg@kroah.com>:
> >> > On Wed, Oct 07, 2009 at 10:14:37PM +0100, Mike Lothian wrote:
> >> >> Hi
> >> >>
> >> >> I was hoping the following patch could be included in 2.6.32 so it
> >> >> would hopefully end up in the next round of distros
> >> >>
> >> >> It adds backlight support for some Samsung laptops
> >> >
> >> > You seem to have lost the original authorship of this patch, and not
> >> > included your signed-off-by for it.
> >> >
> >> > Which means it can't be applied :(
> >> >
> >> > thanks,
> >> >
> >> > greg k-h
> >> >
> >>
> >> It definitely has +MODULE_AUTHOR("Greg Kroah-Hartman
> >> <gregkh@suse.de>"); at the bottom
> >>
> >> I certainly wasn't trying to steal credit for your work
> >
> > I mean on the patch, when submitting it, you need a:
> >        From: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > as the first line.
> >
> >> Who should sign it off?
> >
> > As I stated before, I can not sign off on this patch anymore, but I
> > would like my authorship to remain.  Someone needs to sign off on it...
> >
> >> I think there's a few other models that can be added to this patch too
> >
> > I do too.
> >
> > Note, if you look at the git tree I have for the driver, it is totally
> > rewritten to not use a structure, and instead, use offsets properly.
> > But it removed support for your laptop, which is not what you probably
> > want :(
> >
> > thanks,
> >
> > greg k-h
> >
> 
> What git tree?

http://github.com/gregkh/samsung-backlight

Look at the "laptop" branch for the latest stuff.

Also supports rfkill and "silent" mode for the N130/N128 machines.

thanks,

greg k-h
