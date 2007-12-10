Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXLJSLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXLJSLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbXLJSLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:11:15 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57758 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752183AbXLJSLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:11:14 -0500
Date: Mon, 10 Dec 2007 19:11:12 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-arch@vger.kernel.org
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build
	failure)
Message-ID: <20071210181112.GM20441@stusta.de>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org> <20071128094856.056c0a3f@poseidon.drzeus.cx> <20071128010056.85703a34.akpm@linux-foundation.org> <20071128092856.GV8181@ftp.linux.org.uk> <20071128132916.125e72ec@poseidon.drzeus.cx> <Pine.LNX.4.64.0711281332350.29243@anakin> <20071201215602.7a4710d9@poseidon.drzeus.cx> <Pine.LNX.4.64.0712021219430.29349@anakin> <20071209180818.55bf1443@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071209180818.55bf1443@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 06:08:18PM +0100, Pierre Ossman wrote:
> On Sun, 2 Dec 2007 12:22:31 +0100 (CET)
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > 
> > I gave it a try:
> >   - Remove existing alignment attributes from some device_id types
> >   - Introduce kernel_* types with proper size and alignment for
> >     cross-compilation (sample <asm/kerneltypes.h> for m68k included)
> >   - Introduce BITS_PER_KERNEL_LONG, to make it clearer it applies to the target
> > 
> > Apart from a cross-compile session for m68k, it's untested.
> > 
> 
> This still requires a bit of maintenance to set up a kerneltypes.h for every arch.

Better doing this work once than fixing similar issues again and again.

> It also means we have to be very careful that gcc's internal alignment settings matched the ones in our header.

There's nothing "gcc internal" about struct alignment - remember that 
any change in struct alignment would change our userspace ABI.

> Rgds
> Pierre

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

