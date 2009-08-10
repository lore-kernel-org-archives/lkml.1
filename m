Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZHJPpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZHJPpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZHJPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:45:36 -0400
Received: from kroah.org ([198.145.64.141]:55455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbZHJPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:45:15 -0400
Date: Mon, 10 Aug 2009 08:44:02 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090810154402.GA7701@kroah.com>
References: <20090808194733.38406075@neptune.home>
 <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 11:18:29AM -0400, Alan Stern wrote:
> On Sat, 8 Aug 2009, Bruno [UTF-8] Prémont wrote:
> 
> > I tried bisecting this but bisect did end up on a fully unrelated commit
> > (which is not even being compiled into my kernel).
> > Possibly the failed bisect could be related to mis-classified kernel
> > panic/hang while pulling the USB cable (there were two such panics for the
> > whole iteration)?
> > 
> > There are quite a few patches touching tty, ttyUSB and friends between
> > rc4 and now so pretty hard to guess on the correct one.
> > 
> > The oops always happens when I disconnect the USB serial console (here
> > the one built into Marvell SheevaPlug) while having minicom connected
> > to it.
> > During the bisection for the last few bad iterations minicom got killed
> > (segfault), the bad ones on the iteration left a minicom zombie in 'D'
> > state.
> 
> By the way, there are quite a few serial patches in Greg KH's tree.  At 
> least one of them looks like it is meant to fix exactly this problem.
> 
> Can you try running with
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-all-2.6.31-rc5.patch
> 
> applied to the standard 2.6.31-rc5 source?

Yes, that would be good to find out, so we can pick the right patch to
send in now.

thanks,

greg k-h
