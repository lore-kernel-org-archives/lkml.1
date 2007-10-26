Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXJZEOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXJZEOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXJZEOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:14:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52726 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXJZEOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:14:33 -0400
Date: Thu, 25 Oct 2007 20:28:09 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, bbpetkov@yahoo.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename
	'bInterfaceNumber'
Message-ID: <20071026032809.GA21901@kroah.com>
References: <20071025090659.GA2847@darkstar.te-china.tietoenator.com> <20071025181156.GB10720@kroah.com> <a8e1da0710251901r56c27efdkc7ca729c0bac003d@mail.gmail.com> <20071026024201.GA21311@kroah.com> <a8e1da0710252011j16ef486fvcee7816ce628b2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0710252011j16ef486fvcee7816ce628b2e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 11:11:22AM +0800, Dave Young wrote:
> On 10/26/07, Greg KH <greg@kroah.com> wrote:
> > > Anyway the sysfs_dirent_exist is useful for extern use, How about add
> > > and export this function? Greg, If you agree, I would send it as
> > > another patch.
> >
> > What would need that function?
> I think the function is needed sometimes except for files related to
> devices like usb and others that could be removed suddenly.

Almost all types of devices can now be removed "suddenly" from a system.
Hm, I almost don't know of a type that can _not_ be removed anymore...

But if you have a patch that needs this function, I'd be glad to
reconsider.

thanks,

greg k-h
