Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbZHJSOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbZHJSOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZHJSOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:14:15 -0400
Received: from kroah.org ([198.145.64.141]:47583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZHJSOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:14:15 -0400
Date: Mon, 10 Aug 2009 11:13:06 -0700
From: Greg KH <greg@kroah.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090810181306.GA24989@kroah.com>
References: <20090808194733.38406075@neptune.home>
 <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
 <20090810154402.GA7701@kroah.com>
 <20090810191822.26370810@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090810191822.26370810@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 07:18:22PM +0200, Bruno Prémont wrote:
> On Mon, 10 August 2009 Greg KH <greg@kroah.com> wrote:
> > On Mon, Aug 10, 2009 at 11:18:29AM -0400, Alan Stern wrote:
> > > On Sat, 8 Aug 2009, Bruno Prémont wrote:
> > > 
> > > > I tried bisecting this but bisect did end up on a fully unrelated
> > > > commit (which is not even being compiled into my kernel).
> > > > Possibly the failed bisect could be related to mis-classified
> > > > kernel panic/hang while pulling the USB cable (there were two
> > > > such panics for the whole iteration)?
> > > > 
> > > > There are quite a few patches touching tty, ttyUSB and friends
> > > > between rc4 and now so pretty hard to guess on the correct one.
> > > > 
> > > > The oops always happens when I disconnect the USB serial console
> > > > (here the one built into Marvell SheevaPlug) while having minicom
> > > > connected to it.
> > > > During the bisection for the last few bad iterations minicom got
> > > > killed (segfault), the bad ones on the iteration left a minicom
> > > > zombie in 'D' state.

Ok, a few questions.

Are you pulling the device out when you have a console attached to the
device, or just a "normal" minicom connection with it?  I can't seem to
duplicate this here at the moment for some reason :(

thanks,

greg k-h
