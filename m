Return-Path: <linux-kernel-owner+w=401wt.eu-S1763662AbXJPEOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763662AbXJPEOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 00:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXJPEOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 00:14:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40023 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761002AbXJPEOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 00:14:09 -0400
Date: Tue, 16 Oct 2007 06:15:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Finn Thain <fthain@telegraphics.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071016041541.GA27909@uranus.ravnborg.org>
References: <200710101722.21126.rob@landley.net> <20071012102124.GA18959@uranus.ravnborg.org> <Pine.LNX.4.64.0710152217150.16889@anakin> <200710151931.54289.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710151931.54289.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 07:31:54PM -0500, Rob Landley wrote:
> On Monday 15 October 2007 3:25:35 pm Geert Uytterhoeven wrote:
> > 64-bit parisc tests if /usr/bin/hppa64-linux-gnu- exists.
> > If yes, it sets CROSS_COMPILE to hppa64-linux-gnu-.
> > If no, it sets CROSS_COMPILE to hppa64-linux-
> >
> > 32-bit parisc unconditionally sets CROSS_COMPILE to hppa-linux-.
> >
> > This still breaks Rob's setup if his compiler is called differently.
> 
> Another thing to take into account is that kconfig was recently changed to 
> save ARCH and CROSS_COMPILE in the .config file:
> 
> http://lwn.net/Articles/253889/
The patch is postponed one merge window.
It caused troubles I had not foreseen which needs some attention first.
I plan to have it ready for next merge window.

	Sam
