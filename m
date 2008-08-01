Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYHAQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYHAQsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYHAQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:47:28 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:18958 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578AbYHAQr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:47:26 -0400
Date: Fri, 1 Aug 2008 18:46:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080801164646.GB2299@uranus.ravnborg.org>
References: <200807300907.25186.arnd@arndb.de> <200807312147.25837.arnd@arndb.de> <20080731201352.GB25305@uranus.ravnborg.org> <200808010935.05949.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808010935.05949.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 09:35:04AM +0200, Arnd Bergmann wrote:
> On Thursday 31 July 2008, Sam Ravnborg wrote:
> > > #ifdef __KERNEL__
> > > #ifdef CONFIG_MMU
> > > #include "${BASE}_mmu.h"
> > > #else
> > > #include "${BASE}_nommu.h"
> > > #endif
> > > #else
> > > #include "${BASE}_mmu.h"
> > > #endif
> > > EOF
> > > }
> > 
> > This will leak a CONFIG_ symbol if the header file
> > is exported. Can we do it with a gcc defined symbol?
> > [See how I did it for sparc for instance]
> 
> Is there a compiler defined symbol for this? I thought the tool
> chain was identical.

> Do you think my #ifdef __KERNEL__ does
> not do what I wanted it to do?
Was too quick here - I overlooked the ifdef so it looks good.

	Sam
