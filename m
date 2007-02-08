Return-Path: <linux-kernel-owner+w=401wt.eu-S1423413AbXBHVYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423413AbXBHVYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423414AbXBHVYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:24:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423413AbXBHVYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:24:51 -0500
Date: Thu, 8 Feb 2007 13:23:14 -0800
From: Greg KH <greg@kroah.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
Subject: Re: Git backlight subsystem tree
Message-ID: <20070208212314.GA21165@kroah.com>
References: <1170901826.5859.2.camel@localhost.localdomain> <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org> <1170957595.5849.11.camel@localhost.localdomain> <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 06:32:02PM +0000, James Simmons wrote:
> On Thu, 8 Feb 2007, Richard Purdie wrote:
> 
> > On Thu, 2007-02-08 at 15:28 +0000, James Simmons wrote:
> > > I have some patches that move the backlight away from using the class 
> > > stuff. The only problem is the patch requires all backlight devices 
> > > to be linked to a real struct device. Right now the acpi backligths are 
> > > not.
> > 
> > Why would you want to do that?
> > 
> > The whole point of having this is so that backlights appear as a
> > standard interface under /sys/class/backlight.
> > 
> > An example of why standardised interfaces are good would be someone
> > writing an applet for a handheld to control the backlight brightness.
> > With the class in place, the applet can easily work with any backlight.
> > Without it, it has to be written for each backlight.
> > 
> > So this is a very strong NAK but I'm curious why you'd want to do it...
> 
> I CC Greg to explain. The backlight class didn't go away. The way it is 
> handled is different.

Have a pointer to the patch so I can help explain better?

As a short summary, 'struct class_device' is going away.  Using a
'struct device' in its place is what the conversion should have just
done, no functionality change otherwise.

thanks,

greg k-h
