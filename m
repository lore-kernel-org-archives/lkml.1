Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbXIPUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbXIPUXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXIPUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:23:05 -0400
Received: from mxsf01.insightbb.com ([74.128.0.71]:49849 "EHLO
	mxsf01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbXIPUXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:23:04 -0400
X-IronPort-AV: E=Sophos;i="4.20,261,1186372800"; 
   d="scan'208";a="37032950"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAAot7UZKjlCP/2dsb2JhbACBWA
X-IronPort-AV: E=Sophos;i="4.20,261,1186372800"; 
   d="scan'208";a="127956607"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver (rev3)
Date: Sun, 16 Sep 2007 16:22:58 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <200709140130.59732.dtor@insightbb.com> <20070916215516.2934abad@oldman.hemminger.net>
In-Reply-To: <20070916215516.2934abad@oldman.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161623.00286.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sunday 16 September 2007 15:55, Stephen Hemminger wrote:
> On Fri, 14 Sep 2007 01:30:58 -0400
> Dmitry Torokhov <dtor@insightbb.com> wrote:
> 
> > Hi Stephen,
> > 
> > On Wednesday 12 September 2007 07:38, Stephen Hemminger wrote:
> > > This driver supports the application buttons on some Fujitsu Lifebook laptops.
> > > It is based on the earlier apanel driver done by Jochen Eisenger, but
> > > with many changes.  The original driver used ioctl's and a separate
> > > user space program;  see http://apanel.sourceforge.net/tech.php
> > > This version hooks into the input subsystem so that the normal
> > > Gnome/KDE shortcuts work without any userspace changes.
> > > 
> > > The Mail Led is handled via leds class device.
> > > 
> > 
> > Thank you very much for convering the led to led subsystem. I tried
> > implementing loadable keymap support in the driver, could you please
> > try the patch below and if it still works for you then I will apply
> > it to my tree.
> > 
> 
> Sorry, you are raising the bar for new drivers, higher than existing code.
> It is really bad (second system syndrome), if maintainers keep wanting
> new code to to more than existing drivers.
> 
> Please take driver AS IS. Go ahead and add loadable key map support,

I think I did that. I just asked you to run another test to make sure I did
not screw up. Please find the time to do that and the patch will be applied.
Unfortunately I do not own the hardware in question to do such test myself.

> but fix all the other drivers in the tree at the same time that use the existing
> interface.
> 

I will, time permitting. The support for doing loadable keymaps for drivers
with sparse scancodes (or their equivalent) was added not so long ago,
that's why there are a few drivers that don't implement loadable keymaps.
But still many others do.

-- 
Dmitry
