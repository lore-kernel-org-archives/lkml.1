Return-Path: <linux-kernel-owner+w=401wt.eu-S1764250AbXGROxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764250AbXGROxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXGROwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:52:55 -0400
Received: from [212.12.190.95] ([212.12.190.95]:32872 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753022AbXGROwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:52:54 -0400
From: Al Boldi <a1426z@gawab.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: VESAFB CUSTOM RESOLUTION
Date: Wed, 18 Jul 2007 17:52:29 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707181342.00647.a1426z@gawab.com> <200707181645.01097.a1426z@gawab.com> <1184768426.4523.20.camel@daplas>
In-Reply-To: <1184768426.4523.20.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181752.29478.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Wed, 2007-07-18 at 16:45 +0300, Al Boldi wrote:
> > Antonino A. Daplas wrote:
> > > On Wed, 2007-07-18 at 13:42 +0300, Al Boldi wrote:
> > > > Geert Uytterhoeven wrote:
> > > > > On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> > > >
> > > > Is there any technical reason why vesafb shouldn't support non-BIOS
> > > > modes?
> > >
> > > vesafb can only use modes included by the vendor in the card's BIOS.
> > > The mode table contains standard modes defined by VESA, and perhaps
> > > vendor-defined custom modes. However, the mode ID of custom modes
> > > varies from card to card, so you have to 'probe' the BIOS first for
> > > the list of modes and their associated ID.  X + the 'vesa' driver does
> > > that probe, and so does the lrmi tool vbetest.
> > >
> > > So, one cannot just set any mode, unless that mode is already defined
> > > in the BIOS mode table. In VBE 3.0, you might be able to choose an
> > > arbitrary vertical refresh rate, but that's the best mode tuning you
> > > can do with the video BIOS.
> >
> > Thanks for a great explanation!
> >
> > Looks like this chip supports VBE 3.0, but it only locks into 60Hz
> > refresh. Here is an excerpt; full log attached.
>
> What you need to look at the X log is this particular part (this is the
> output of my card, and for the sake of brevity, I removed the
> descriptive sections):

Here are mine; I tried them all, and they always lock into 60Hz refresh.

Mode: 101 (640x480)
Mode: 112 (640x480)
Mode: 103 (800x600)
Mode: 115 (800x600)
Mode: 105 (1024x768)
Mode: 118 (1024x768)
Mode: 179 (1280x768)
Mode: 17b (1280x768)
Mode: 107 (1280x1024)
Mode: 11b (1280x1024)
Mode: 120 (1600x1200)
Mode: 122 (1600x1200)
Mode: 124 (1600x1200)
Mode: 199 (1920x1440)
Mode: 19a (1920x1440)
Mode: 19b (1920x1440)
Mode: 22e (800x480)
Mode: 230 (800x480)
Mode: 108 (80x60)
Mode: 102 (800x600)


What about the VBE 3.0 arbitrary vertical refresh rate thing?


Thanks!

--
Al

