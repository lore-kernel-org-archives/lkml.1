Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbYD0U3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbYD0U3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYD0U25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:28:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42352 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbYD0U24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:28:56 -0400
Date: Sun, 27 Apr 2008 22:29:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] ARM: always select HAVE_IDE
Message-ID: <20080427202929.GB32762@uranus.ravnborg.org>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080417110005.GE1449@flint.arm.linux.org.uk> <20080417132507.GA9314@cs181133002.pp.htv.fi> <200804272032.44273.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804272032.44273.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > I do actually not care much how this gets resolved (we could even 
> > ditch HAVE_IDE and provide asm/ide.h on all architectures) if there's 
> > general agreement that this is the way to go.
> 
> Seems like a way to go now that all crazy IDE core code vs arch code
> inter-dependiences have been fixed (the ideal solution would be to ditch
> asm/ide.h completely but this requires some more time/work).

I invented HAVE_IDE in the past to make it trivial for arm to
use drivers/Kconfig.
And that incentive are not broken by your suggestion so fine with me.

But I really do not know about s390. They were the only one
without IDE in the past.

	Sam
