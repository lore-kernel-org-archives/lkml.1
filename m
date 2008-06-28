Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYF1PgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYF1PgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYF1Pfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:35:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:48498 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYF1Pfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:35:53 -0400
Date: Sat, 28 Jun 2008 08:33:10 -0700
From: Greg KH <greg@kroah.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628153309.GC11018@kroah.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com> <1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com> <20080628153403.0870e96c@mjolnir.drzeus.cx> <20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com> <20080628155913.2bba34a9@mjolnir.drzeus.cx> <20080628160752.0fe19753@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080628160752.0fe19753@hskinnemo-gx745.norway.atmel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 04:07:52PM +0200, Haavard Skinnemoen wrote:
> Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > On Sat, 28 Jun 2008 15:47:00 +0200
> > Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > 
> > > Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > > 
> > > > Can't we use debugfs' own bookkeeping to keep track of them? Saves us a
> > > > lot of noise in these structures.
> > > 
> > > You mean d_subdirs in struct dentry? I guess we could do that...though
> > > I was sort of trying not to dig too deply into VFS internals...
> > > 
> > 
> > I'm a complete noob when it comes to debugfs. There isn't some
> > recursive delete function that can be used on the "ios" node?
> 
> I don't think so, but I think it would be very useful. I sometimes
> forget to remove an entry so that I have to reboot in order to get my
> driver's debugfs interface going again..
> 
> Greg, do you have any suggestions?

Someone can add a "debugfs_rm_dentry_and_children" function if they so
desire to handle this kind of thing if they want to :)

thanks,

greg k-h
