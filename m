Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbXBLAPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbXBLAPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXBLAPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:15:36 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40867 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbXBLAPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:15:35 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Willy Tarreau <w@1wt.eu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200702120109.56564.rjw@sisk.pl>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <200702120050.24539.rjw@sisk.pl>
	 <1171238117.4493.153.camel@nigel.suspend2.net>
	 <200702120109.56564.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 11:15:35 +1100
Message-Id: <1171239335.4493.163.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 01:09 +0100, Rafael J. Wysocki wrote:
> On Monday, 12 February 2007 00:55, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Mon, 2007-02-12 at 00:50 +0100, Rafael J. Wysocki wrote:
> > > On Monday, 12 February 2007 00:47, Nigel Cunningham wrote:
> > > > Hi.
> > > > 
> > > > On Mon, 2007-02-12 at 00:41 +0100, Rafael J. Wysocki wrote:
> > > > > > I'm using M$ hibernation and Suspend2 to dual boot on our desktop (dtv
> > > > > > card that Linux doesn't support well yet), and I know other Suspend2
> > > > > > users doing the same. It's made earier by the fact that Suspend2 lets
> > > > > > you reboot instead of powering down.
> > > > > 
> > > > > Well, I don't know why you're saying it's a special capability of suspend2.
> > > > > Even the "old" swsusp has been able to do this since I can remember. ;-)
> > > > 
> > > > It does?! I just did cat /sys/power/disk and it only says platform. How
> > > > do you make swsusp reboot instead of powering down?
> > > 
> > > echo reboot > /sys/power/disk && echo disk > /sys/power/state
> > 
> > Ah. Perhaps you should make it show reboot when you cat it?
> 
> albercik:~ # echo reboot > /sys/power/disk
> albercik:~ # cat /sys/power/disk
> reboot
> 
> It shows the current value, and "platform" happens to be the default now.

Oh, so the problem is that it shows the current value, not the
possibilities. I wrongly assumed it would work like /sys/power/disk.
That explains it :)

Regards,

Nigel

