Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYDMRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYDMRqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYDMRqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:46:09 -0400
Received: from mail.suse.de ([195.135.220.2]:55041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYDMRqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:46:08 -0400
Date: Sun, 13 Apr 2008 10:51:57 -0700
From: Greg KH <gregkh@suse.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080413175157.GA21473@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx> <20080404210132.GA14418@suse.de> <20080405115727.1265e8a9@mjolnir.drzeus.cx> <20080405155323.GA27252@suse.de> <20080405185501.41ec42a7@mjolnir.drzeus.cx> <20080405171209.GA28388@suse.de> <20080405202709.2cd03212@mjolnir.drzeus.cx> <20080408034126.GA15563@suse.de> <20080413143311.77fd4b44@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413143311.77fd4b44@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 02:33:11PM +0200, Pierre Ossman wrote:
> On Mon, 7 Apr 2008 20:41:26 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Sat, Apr 05, 2008 at 08:27:09PM +0200, Pierre Ossman wrote:
> > > 
> > > No, it's primarily desktop. But these chips are available as
> > > ExpressCards, so I'm trying to get them to work when hot-plugged as
> > > opposed to when permantently wired into the machine.
> > 
> > Then I suggest a thread/timer, it shouldn't be that difficult.
> > 
> 
> I have another idea. Is it guaranteed that the PCI subsystem will add
> devices in order? I.e. will 1f.0 be added before 1f.1, 1f.2 and so on?
> If so, then I can restructure things and get it to work properly
> without any timers.

Yes, that should the be the order in which devices are always scanned.

> Btw, is your @kroah address working? I have a kernel bugzilla entry I
> was hoping to get your input on.

Yes, that address works very well...

thanks,

greg k-h
