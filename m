Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbXC3F1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbXC3F1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXC3F1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:27:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40119 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbXC3F1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:27:49 -0400
Date: Thu, 29 Mar 2007 22:26:07 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: new sysfs layout and ethernet device names
Message-ID: <20070330052607.GA26835@kroah.com>
References: <20070320170102.GA16341@nostromo.devel.redhat.com> <3ae72650703220147j42db8f79s734d4755c2fa43fd@mail.gmail.com> <20070328031743.GA11819@nostromo.devel.redhat.com> <20070328041005.GA7550@kroah.com> <20070329004138.GA23562@nostromo.devel.redhat.com> <20070330023104.GA21771@kroah.com> <20070330032905.GA4384@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330032905.GA4384@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 11:29:05PM -0400, Bill Nottingham wrote:
> Greg KH (greg@kroah.com) said: 
> > > If interfaces have to change, so be it. But changing the rules for
> > > using them years after it's implemented and then claiming "you didn't
> > > read the instructions" is pretty lame.
> > 
> > That documentation has been in the kernel tree for almost a full year:
> 
> It has a date on it. I'm not blind. That doesn't change the fact that
> that documentation:
> 
> > 	Date:   Thu Apr 27 14:10:12 2006 -0700
> 
> postdates the interface it's describing by at *least* two years. Which
> was the point of my mail that you conveniently ignored - retroactively
> deciding which parts of the interface you export to userspace shouldn't be
> used falls way short of best practices.

I am not disagreeing with that, that is why the config option is
present.

> > Anyway, yes, older code should still "just work" if you enable the
> > CONFIG_SYSFS_DEPRECATED config option in the kernel, that is what it is
> > there for.
> 
> It appears to... the point was that (as far as the code is concerned)
> it's a silent break. Of course, code that expects the 'current' layout
> will then break when this new change is made, unless you add
> CONFIG_SYSFS_SLIGHTLY_LESS_DEPRECATED?

Well, the idea is that over time, older things will move under this
config option.  If you disable it, you will have a "cleaner" sysfs tree,
but if you enable it, it should all just look the same.

Now some people have proposed versioning the sysfs interface (1, 2, 3,
etc.) and have a config option for that.  I don't know if that's really
necessary just yet, but am considering it for future changes.

thanks,

greg k-h
