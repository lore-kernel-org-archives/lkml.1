Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbYEOVMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbYEOVMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYEOVMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:12:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbYEOVMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:12:23 -0400
Date: Thu, 15 May 2008 14:11:17 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515211117.GA32573@kroah.com>
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515184034.GB15231@kroah.com> <20080515205959.GA11683@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515205959.GA11683@dose.home.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:59:59PM +0200, Tino Keitel wrote:
> On Thu, May 15, 2008 at 11:40:34 -0700, Greg KH wrote:
> > On Thu, May 15, 2008 at 09:45:52AM -0400, Dmitry Torokhov wrote:
> > > Hi Tino,
> > > 
> > > On Thu, May 15, 2008 at 03:21:08PM +0200, Tino Keitel wrote:
> > > > Hi,
> > > >
> > > > I'm pretty sure that this breaks the macmini LIRC driver again, see
> > > > commit 3e1928e8793208802589aae851b6685671187242.
> > > >
> > > 
> > > But with in-kernel driver can't LIRC feed of event device? Ane people
> > > that dont use LIRC can also have access to the remote?
> > 
> > And, to be blunt, why would an in-kernel driver be concerned about an
> > out-of-tree-project-that-refuses-to-be-included chunk of code?
> 
> The macmini LIRC driver is a pure userspace driver, so nothing needs to
> be ever included in the kernel.

So does this driver work with the macmini USB ir device today somehow?

>From what I can tell, this driver is still necessary for things to work
properly for this hardware, right?

I'm totally confused now...

greg k-h
