Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYG3ItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYG3ItX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYG3ItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:49:10 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:35470 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYG3ItH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:49:07 -0400
Date: Wed, 30 Jul 2008 10:49:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org, geert@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m68k build failure
Message-ID: <20080730084935.GA18545@uranus.ravnborg.org>
References: <20080730175233.02dbf021.sfr@canb.auug.org.au> <20080730.010234.193703201.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730.010234.193703201.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 01:02:34AM -0700, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 30 Jul 2008 17:52:33 +1000
> 
> > linux-next (version next-20080729) build (m68k defconfig) failed like this;
> > 
> > In file included from arch/m68k/sun3/idprom.c:16:
> > include2/asm/idprom.h:3:30: error: asm-sparc/idprom.h: No such file or directory
> 
> Yes, Sam told the m68k folks this would happen and that they
> would need to resolve it somehow.
> 
> Perhaps as a quick fix we can just copy sparc's idprom.h into
> asm-m68k/idprom.h

Full list of relevant files:
include/asm-m68k/contregs.h:#include <asm-sparc/contregs.h>
include/asm-m68k/fbio.h:#include <asm-sparc/fbio.h>
include/asm-m68k/idprom.h:#include <asm-sparc/idprom.h>

I will try to take a look at it tonight. m68knommu is
also part of the game.
Need to get x86 + um working with arch/x86/include first though.

	Sam
