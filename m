Return-Path: <linux-kernel-owner+w=401wt.eu-S938534AbXFHKSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938534AbXFHKSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937708AbXFHKSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:18:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51664 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937539AbXFHKSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:18:06 -0400
Date: Fri, 8 Jun 2007 12:17:48 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Robert de Rooy <robert.de.rooy@gmail.com>
cc: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net
Subject: Re: ThinkPad T41 - Strange USB 2.0 behaviour
In-Reply-To: <46692ADC.4050604@gmail.com>
Message-ID: <Pine.LNX.4.64.0706081217340.23280@twin.jikos.cz>
References: <46686937.9050306@gmail.com> <20070607205015.GD6528@ca-server1.us.oracle.com>
 <46687BD3.1020603@gmail.com> <Pine.LNX.4.64.0706081110330.23280@twin.jikos.cz>
 <46692ADC.4050604@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-usb-devel list added

On Fri, 8 Jun 2007, Robert de Rooy wrote:

> Jiri Kosina wrote:
> > On Thu, 7 Jun 2007, Robert de Rooy wrote:
> >
> >   
> > > Yes I figured it was a hardware problem, but that was not really the point
> > > I was trying to raise ;). I would like, if possible for Linux to
> > > automatically fallback to USB 1.1 like Windows does (preferably with a
> > > suitable warning).
> > >     
> >
> > What do you propose as a trigger for the kernel to fallback?
> >
> > You can work it around manually, just don't use ehci-hcd, can't you?
> >
> >   
> Yes I can unload ehci-hcd, but I have one USB 2.0 device that strangely enough
> DOES work as such, and unloading ehci-hcd will cause that also to run at 1.1
> speed.
> 
> Clearly something is failing when plugging a device with ehci-hcd loaded, the
> driver seems to keep retrying indefinitely. Instead it would be nice if after
> a few tries it hands the device over to uhci-hcd. This seems to be the
> behaviour under Windows, so I was wondering if Linux could be made to do
> something similar.
> 
> 

-- 
Jiri Kosina
