Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZAJMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZAJMbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZAJMbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:31:10 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:35459 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZAJMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:31:09 -0500
Date: Sat, 10 Jan 2009 04:31:06 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Richard Purdie <rpurdie@rpsys.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Guennadi Liakhovetski <lg@denx.de>,
       linuxppc-dev@ozlabs.org
Subject: Re: [GIT PULL] LED updates for 2.6.29
In-Reply-To: <1231543199.5317.63.camel@dax.rpnet.com>
Message-ID: <Pine.LNX.4.58.0901100428230.1626@shell2.speakeasy.net>
References: <1231500186.5317.9.camel@dax.rpnet.com> 
 <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp>
 <1231543199.5317.63.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Richard Purdie wrote:
> On Fri, 2009-01-09 at 12:37 -0800, Trent Piepho wrote:
> > On Fri, 9 Jan 2009, Richard Purdie wrote:
> > > for the LED tree updates for 2.6.29. This includes some new drivers,
> > > bugfixes and a core improvement resulting in nicer code.
> > >
> >
> > Any chance of these patches getting accepted?  They've been going back and
> > forth for months now.
> >
> > [v2,1/4] leds: Support OpenFirmware led bindings
> > http://patchwork.ozlabs.org/patch/13581/
> >
> > [v2,2/4] leds: Add option to have GPIO LEDs start on
> > http://patchwork.ozlabs.org/patch/13580/
> >
> > [v2,3/4] leds: Let GPIO LEDs keep their current state
> > http://patchwork.ozlabs.org/patch/13583/
> >
> > [v2,4/4] leds: Use tristate property in platform data
> > http://patchwork.ozlabs.org/patch/13584/
>
> I think there was some confusion as to who was going to take them. Are
> the PPC people happy with them? If so I'll merge through the LED tree.
> There are these and a couple of other patches around which have got lost
> in the system. If there is time which I'm hoping there might be, I'll
> try and get a second LED tree merge in.

The LED tree makes more sense for what's left I think.  There was a
openfirmware gpio patch, but that's already gone in.  What's left only
touches led files and the device tree binding docs.

AFAIK, there were no objections to the patches left.
