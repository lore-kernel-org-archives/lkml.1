Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXDPPfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXDPPfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXDPPfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:35:09 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:57566 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbXDPPfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:35:07 -0400
From: CIJOML <cijoml@volny.cz>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
Date: Mon, 16 Apr 2007 17:00:54 +0200
User-Agent: KMail/1.9.5
Cc: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <1176653207.10849.5.camel@localhost> <4622C462.8020505@linuxtv.org> <20070416141535.GB10338@stusta.de>
In-Reply-To: <20070416141535.GB10338@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704161700.54905.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more addiction:

As a side effect this fixes also kernel crash, when you swsusp/swresume with 
USB dongle and playing DVB stream. 

Michal

Dne pondělí 16 duben 2007 16:15 Adrian Bunk napsal(a):
> On Sun, Apr 15, 2007 at 08:33:38PM -0400, Michael Krufky wrote:
> > Mauro,
> >
> > I've been out of town for the past few days... I just got home and saw
> > this:
> >
> > Mauro Carvalho Chehab wrote:
> > >    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
> > >    - Fix 2/3 for bug 7819: demux and dvr
> > >    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> >
> > I don't think that this is 2.6.21 material.  These patches have not yet
> > received
> > enough testing to be sent to mainline.
> >
> > I have tested them, and they seem to work for my cxusb device, but we
> > have yet to hear test results from users of usb dvb devices that do not
> > use the dvb-usb framework.  (ttusb, flexcop-usb, cinergyT2, for example)
> >
> > The bug that these patches fix has been around throughout the entire
> > kernel history of the dvb subsystem.  The bug is not a regression -- it
> > has always been
> > there.  In my opinion, it is too late in 2.6.21 development to apply
> > this change.
> > Because these fixes are not obvious, I think we should let them get some
> > more testing, and have them queued for 2.6.22 .
>
> Unless I misunderstand anything, this should fix [1].
>
> And this is a bug that was reported to be present in 2.6.21-rc but not
> in 2.6.20 (and it's therefore a regression, no matter whether the
> underlying problem was older and only exposed by some other change).
>
> > Regards,
> >
> > Michael
>
> cu
> Adrian
>
> [1] http://lkml.org/lkml/2007/3/9/212
