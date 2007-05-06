Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXEFUUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXEFUUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbXEFUUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:20:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:56093 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755258AbXEFUUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:20:33 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19elDc1+iheIBdDjsq5ed1xv565NAfGUo9/z3WPJJ
	ZOVRFP2evGVFxk
Date: Sun, 6 May 2007 22:20:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Stefan Roese <ml@stefan-roese.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Correct location for ADC/DAC drivers
In-Reply-To: <E1Hkfia-0000cJ-18@be1.lrz>
Message-ID: <Pine.LNX.4.60.0705062219310.6650@poirot.grange>
References: <8fZXU-3EI-11@gated-at.bofh.it> <8haHG-6zd-19@gated-at.bofh.it>
 <8hd2U-1Ca-39@gated-at.bofh.it> <8heii-3GM-37@gated-at.bofh.it>
 <E1Hkfia-0000cJ-18@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Bodo Eggert wrote:

> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > On Fri 4 May 2007 16:52, Robert Schwebel pondered:
> >> On Fri, May 04, 2007 at 02:21:50PM -0400, Robin Getz wrote:
> 
> >> > We also have DAC and ADC drivers (up to 16 bits @ 64MS/s, via DMA),
> >> > that would be nice to put in the "right" place  - I don't think that
> >> > drivers/char is the right place, nor drivers/misc - I also don't think
> >> > that /adc is a descriptive place for DAC or mixed signal front ends
> >> > (MxFE).
> >>
> >> What userspace interface do your drivers have?
> > 
> > Right now, it is a little rudimentary char interface, it needs a little care
> > to be a bit more general purpose, but it suited needs of what the people who
> > were using it.

If I were thinking about a DAC / ADC API I would have a look at Comedi - 
somehow I think it should be pretty well designed...

Thanks
Guennadi
---
Guennadi Liakhovetski
