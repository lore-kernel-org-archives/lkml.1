Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYIKOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYIKOc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYIKOcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:32:50 -0400
Received: from mail.queued.net ([207.210.101.209]:3481 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYIKOct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:32:49 -0400
Date: Thu, 11 Sep 2008 10:32:28 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080911103228.3a55d1b3@dev.queued.net>
In-Reply-To: <20080911090103.ZZRA012@mailhub.coreip.homeip.net>
References: <20080813152459.4d6bb0cb@ephemeral>
	<20080815031435.GD9438@anvil.corenet.prv>
	<20080910175513.17d900bc@dev.queued.net>
	<20080911010124.79166d64@dev.queued.net>
	<20080911013209.3d7c70da@dev.queued.net>
	<20080911090103.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 09:05:22 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Thu, Sep 11, 2008 at 01:32:09AM -0400, Andres Salomon wrote:
> > 
> > And here's the current touchpad driver after updating based upon
> > your comments.
> > 
> 
> Looks good. Care to respin it all thogether based on the attribute
> change I requested so I can be sure I'm applying the latest version of
> everything? Ummm....
> 

Thanks, will do.


> > diff --git a/drivers/input/mouse/Kconfig
> > b/drivers/input/mouse/Kconfig index 7bbea09..fff0253 100644
> > --- a/drivers/input/mouse/Kconfig
> > +++ b/drivers/input/mouse/Kconfig
> > @@ -96,6 +96,16 @@ config MOUSE_PS2_TOUCHKIT
> >  
> >  	  If unsure, say N.
> >  
> > +config MOUSE_PS2_OLPC
> > +	bool "OLPC PS/2 mouse protocol extension"
> > +	depends on MOUSE_PS2 && OLPC
> 
> Are you sure it shoudl depend on OLPC? It looks like driver should
> work on any box with PS/2 port. I understand that only OLPC has the
> hardware installed but can this change?
> 
> Thanks!
> 

Positive; the majority of this driver is just workarounds for bugs in
the hardware that are specific to OLPC.  If we didn't have to
deal with flaky hardware and recalibrations, we could just
use standard psmouse without extensions.  :/
