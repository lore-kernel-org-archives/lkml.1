Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYHAVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYHAVWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbYHAVPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:15:32 -0400
Received: from mail.queued.net ([207.210.101.209]:4448 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762011AbYHAVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:15:30 -0400
Date: Fri, 1 Aug 2008 17:15:18 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OLPC: psmouse: touchpad driver
Message-ID: <20080801171518.4c041a47@fred>
In-Reply-To: <20080801143150.ZZRA012@mailhub.coreip.homeip.net>
References: <20080801142004.2d3d1349@fred>
	<20080801143150.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 14:34:51 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Fri, Aug 01, 2008 at 02:20:04PM -0400, Andres Salomon wrote:
> > 
> > This adds support for OLPC's touchpad.  It has lots of neat
> > features, none of which are enabled because the hardware is too
> > buggy.  Instead, we use it like a normal touchpad, but with a
> > number of workarounds in place to deal with the frequent hardware
> > spasms.  Humidity changes, sweat, tinfoil underwear, plugging in
> > AC, drinks, evil felines.. All tend to cause the touchpad to freak
> > out.
> > 
> > Stuff like this keeps me from getting bored.
> > 
> 
> Good stuff, thank you. I bet you named the module olpc and gave pregix
> hgpk to all the functions to mess with mt feeble brain ;) Maybe we
> should rename the module to hgpk as well?
> 

I thought about it, but decided not to for now now (olpc.c is what
people will recognize it as; people familiar w/ the spec will recognize
it as HGPK).  Granted, olpc.c is not a good long term name, as hardware
will most definitely be changed in the XO-2 (and maybe even before
then, who knows?)

So, I wouldn't be against renaming it hgpk.c, but I'm not sure that
people would recognize it when looking for it.


> > From psmouse-base, we use psmouse_set_state quite a bit, as well
> > as piggy-backing off of kpsmoused_wq; so, this also makes those
> > available to protocol extensions.
> >
> 
> Do you think we should provide assessor functions to deal with
> kpsmoused instead of playing with it directly? I was thinking about
> starting it on-demand for protocols that may use it and shut it off by
> default.
> 

Sure.  Do you already have code to do the on-demand stuff, so I can
make sure what I end up writing works w/ your code?
