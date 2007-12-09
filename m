Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXLIGoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXLIGoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXLIGoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:44:37 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:58962 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbXLIGog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:44:36 -0500
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build
	failure)
From: Jon Masters <jonathan@jonmasters.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Pierre Ossman <drzeus@drzeus.cx>, Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <20071208215811.GD20441@stusta.de>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	 <20071201215602.7a4710d9@poseidon.drzeus.cx>
	 <Pine.LNX.4.64.0712021219430.29349@anakin>
	 <200712032102.20353.rusty@rustcorp.com.au>
	 <20071208215811.GD20441@stusta.de>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 09 Dec 2007 01:43:30 -0500
Message-Id: <1197182610.12636.11.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 22:58 +0100, Adrian Bunk wrote:
> On Mon, Dec 03, 2007 at 09:02:19PM +1100, Rusty Russell wrote:
> > On Sunday 02 December 2007 22:22:31 Geert Uytterhoeven wrote:
> > > On Sat, 1 Dec 2007, Pierre Ossman wrote:
> > > > Yeah, that could work. Have a header with stuff like this:
> > > >
> > > > typedef u16 __attribute__((aligned(2))) aligned_u16;
> > > > typedef u32 __attribute__((aligned(4))) aligned_u32;
> > >
> > > I gave it a try:
> > 
> > This seems to turn a molehill into a mountain.
> > 
> > We can change that mod_devicetable.h at any time; it's not supposed to be a 
> > userspace API (the kernel build system doesn't count).
> 
> module-init-tools is userspace and not shipped as part of the kernel 
> build system...

Not really an issue, so long as I get a head's up, but we'll force users
to upgrade so let's be sure we want to do this/everyone's happy.

Jon.


