Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXDQDnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXDQDnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 23:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXDQDnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 23:43:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52100 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXDQDnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 23:43:10 -0400
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: CIJOML <cijoml@volny.cz>, Adrian Bunk <bunk@stusta.de>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4623A391.9060604@linuxtv.org>
References: <1176653207.10849.5.camel@localhost>
	 <20070416141535.GB10338@stusta.de> <462397A0.4040603@linuxtv.org>
	 <200704161818.26686.cijoml@volny.cz>  <4623A391.9060604@linuxtv.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 00:42:23 -0300
Message-Id: <1176781343.1459.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have tested these patches with 2.6.20-mh1 + v4l-dvb-b5be3479f070 patchset.
> > I also tried 2.6.21-rc6 + v4l-dvb-b5be3479f070 patchset and this combination 
> > also works without OOPS.
> >   
> Yes, that shows that the changesets prevent the oops, but it says
> nothing about vanilla 2.6.20.y
> > Winfast dongles are both dvb-usb based (DiBcom 3000M-C and DiBcom DiB7000P), 
> > but pluto2 is cardbus (pci) based.
> >   
> just as I figured.  The pluto2 test results are great to hear, though --
> thank you.
> > I think we can include these patches into 2.6.21 and if we receive any 
> > problem, we still have 2.6.21.Z for fixing, don't we?
> 
> The stable kernel series is not there for that purpose.  It is not there
> to encourage a rush of patches into a final kernel release, only to
> cause potential problems, with the 2.6.x.y series as a fallback for
> fixes.  We should avoid the need for such last-minute fixes wherever
> possible.
For sure we should do the best to avoid regressions. But, IMO, a driver
for a hotpluggable device (USB) that can't support device hot plug is a
serious issue. 

If nobody have an issue pointing regressions on this, we should really
apply the fix for 2.6.21.

-- 
Cheers,
Mauro

