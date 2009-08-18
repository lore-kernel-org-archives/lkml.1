Return-Path: <linux-kernel-owner+w=401wt.eu-S1751174AbZHRExh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbZHRExh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbZHRExg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:53:36 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:59414 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZHRExg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:53:36 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 00:53:36 EDT
Date: Tue, 18 Aug 2009 00:43:25 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Tobias_Mueller@twam.info
Cc: David Brownell <david-b@pacbell.net>, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>, deepak@laptop.org,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       linux-geode@lists.infradead.org, jordan@cosmicpenguin.net,
       cjb@laptop.org
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver  
 support
Message-ID: <20090818004325.2c44e3ee@mycelium.queued.net>
In-Reply-To: <17be05570908150359t2cfafac3if43a2dc55a1a7195@mail.gmail.com>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	<17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
	<20090611172850.6c418b1d@mycelium.queued.net>
	<200907011532.34677.david-b@pacbell.net>
	<17be05570908150359t2cfafac3if43a2dc55a1a7195@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009 12:59:48 +0200
Tobias Müller <Tobias_Mueller@twam.info> wrote:

> 2009/7/2 David Brownell <david-b@pacbell.net>:
> > Correct-but-annoying ... and maybe worth changing.  The
> > direction *displayed* may not reflect the actual hardware
> > until after that GPIO signal is initialized.  Boot firmware
> > may well have set the direction; Linux shouldn't change it
> > without explicit instructions to do so.
> OK. If this is a know problem with all GPIO drivers, we can
> skip these to two lines to set in pin a defined state.
> 
> > So it would be nice to remove the heuristic.  The best
> > way would be to add a new method to query gpio direction.
> > Then that when it's available, instead of the heuristic.
> This can be implemented when the GPIO interface supports it.
> 
> The problem with the mask still occurs. I changed to default
> mask to 0x0F7FFFFF, so that all pins except the reserved
> ones and the power-pin (which needs special handling) are
> enabled. Shall we keep it this way (which I prefer) or delete
> it entirely?
> 

Hi Tobias,

At this point, I've lost track of all the changes that need to be
made.  Would you mind submitting your current patch w/ all of the
updates we talked about, and we can go from there?  If possible, it'd
be nice to get the cs5535-gpio stuff into the next merge window (but
we'd need to get moving on this now in order to do that).

