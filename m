Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbYEIQRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbYEIQRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYEIQRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:17:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbYEIQQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:16:59 -0400
Date: Fri, 9 May 2008 08:19:24 -0700
From: Greg KH <greg@kroah.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080509151924.GA30644@kroah.com>
References: <20080505080227.GA5499@ics.muni.cz> <20080508202921.GA32617@kroah.com> <20080509092006.GI31771@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509092006.GI31771@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:20:06AM +0200, Lukas Hejtmanek wrote:
> On Thu, May 08, 2008 at 01:29:21PM -0700, Greg KH wrote:
> > On Mon, May 05, 2008 at 10:02:27AM +0200, Lukas Hejtmanek wrote:
> > > Hello,
> > > 
> > > as of some high versions of 2.6.25-gitXX and 2.6.26-rc1, USB devices pluged
> > > into a dock (minidock for Lenovo ThinkPad T61) are not discoverred until
> > > I reload ehci-hcd module with already plugged device.
> > 
> > Can you please post the kernel log file from when this happens?
> 
> I created an attachment to this bug.
> http://bugzilla.kernel.org/show_bug.cgi?id=10630

I'd prefer to do this in email, not bugzilla, if you can.

That log file has a lot of suspend/resume cycles (showing some acpi
problems as well...)

Can you just boot the box and then plug it into the dock and show the
log file for that?

thanks,

greg k-h
