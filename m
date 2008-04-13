Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYDMMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYDMMeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbYDMMeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:34:06 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:55670 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbYDMMeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:34:05 -0400
Date: Sun, 13 Apr 2008 14:33:11 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080413143311.77fd4b44@mjolnir.drzeus.cx>
In-Reply-To: <20080408034126.GA15563@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	<20080404210132.GA14418@suse.de>
	<20080405115727.1265e8a9@mjolnir.drzeus.cx>
	<20080405155323.GA27252@suse.de>
	<20080405185501.41ec42a7@mjolnir.drzeus.cx>
	<20080405171209.GA28388@suse.de>
	<20080405202709.2cd03212@mjolnir.drzeus.cx>
	<20080408034126.GA15563@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008 20:41:26 -0700
Greg KH <gregkh@suse.de> wrote:

> On Sat, Apr 05, 2008 at 08:27:09PM +0200, Pierre Ossman wrote:
> > 
> > No, it's primarily desktop. But these chips are available as
> > ExpressCards, so I'm trying to get them to work when hot-plugged as
> > opposed to when permantently wired into the machine.
> 
> Then I suggest a thread/timer, it shouldn't be that difficult.
> 

I have another idea. Is it guaranteed that the PCI subsystem will add
devices in order? I.e. will 1f.0 be added before 1f.1, 1f.2 and so on?
If so, then I can restructure things and get it to work properly
without any timers.

Btw, is your @kroah address working? I have a kernel bugzilla entry I
was hoping to get your input on.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
