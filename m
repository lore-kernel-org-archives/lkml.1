Return-Path: <linux-kernel-owner+w=401wt.eu-S1423243AbXBHSwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423243AbXBHSwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423247AbXBHSws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:52:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423243AbXBHSws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:52:48 -0500
Date: Thu, 8 Feb 2007 10:51:38 -0800
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 10/28] SERIO: add the sysfs driver name to all modules
Message-ID: <20070208185138.GA18606@kroah.com>
References: <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <d120d5000702080920k5ea09180i8d9608ac1c9857db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000702080920k5ea09180i8d9608ac1c9857db@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 12:20:05PM -0500, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On 2/7/07, Greg KH <greg@kroah.com> wrote:
> >From: Greg Kroah-Hartman <gregkh@suse.de>
> >
> >This adds the module name to all SERIO drivers, if they are built into
> >the kernel or not.  It will show up in /sys/modules/MODULE_NAME/drivers/
> >
> 
> What is this needed for?

All modules show up today in /sys/module/ no matter if they are built
into the kernel or not.

But, if they are built as a module, the /sys/module/drivers/ link was
present.  This is not consistant, as we always want to see that link, no
matter if the driver is built in or not.  So with this change, we now
always see the links.

I also fixed the PCI and USB drivers to do this as well.

Hope this helps explain it.

thanks,

greg k-h
