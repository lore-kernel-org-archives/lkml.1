Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZHGDHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZHGDHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHGDHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:07:36 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:55214 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZHGDHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:07:35 -0400
X-ASG-Debug-ID: 1249614456-7d7900e20000-xx1T2L
X-Barracuda-URL: http://10.68.76.222:80/cgi-bin/mark.cgi
Date: Thu, 6 Aug 2009 23:07:33 -0400 (EDT)
From: Nicolas Pitre <nico@marvell.com>
X-X-Sender: nico@xanadu.home
To: Ben Dooks <ben-linux@fluff.org>
Cc: Dhaval Vasa <dhaval.vasa@einfochips.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rabeeh Khoury <rabeeh@marvell.com>
X-ASG-Orig-Subj: Re: [PATCH] [ARM] Kirkwood: Marvell OpenRD-Base board support added
 to v2.6.31-rc5
Subject: Re: [PATCH] [ARM] Kirkwood: Marvell OpenRD-Base board support added
 to v2.6.31-rc5
In-Reply-To: <20090806230726.GA19624@fluff.org.uk>
Message-ID: <alpine.LFD.2.00.0908062303390.16073@xanadu.home>
References: <1249567753-724-1-git-send-email-dhaval.vasa@einfochips.com> <20090806230726.GA19624@fluff.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1249614456
X-Barracuda-Virus-Scanned: by dakia2.marvell.com at marvell.com
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009, Ben Dooks wrote:

> On Thu, Aug 06, 2009 at 07:39:13PM +0530, Dhaval Vasa wrote:
> > reference:
> > http://open-rd.org
> > http://code.google.com/p/openrd
> > 
> > This patch is tested for:
> > 1. Boot from DRAM/NAND flash
> > 2. NAND read/write/erase
> > 3. GbE0
> > 4. USB read/write
> > 
> > FIXME:
> > 1. SD/UART1 selection
> > 2. MPP configuration (currently, default)
> > 3. PEX
> > 
> > Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
> 
> You forgot to cc: linux-arm-kernel@lists.arm.linux.org.uk, although
> someone really should issue a MAINTAINERS entry for that machine
> directory.

Yep, I'll take care of it.

> > ---
> >  arch/arm/mach-kirkwood/Kconfig             |    5 ++
> >  arch/arm/mach-kirkwood/Makefile            |    1 +
> >  arch/arm/mach-kirkwood/openrd_base-setup.c |   79 ++++++++++++++++++++++++++++
> >  3 files changed, 85 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/mach-kirkwood/openrd_base-setup.c
> 
> call this openrd.c or openrd_base.c, the -setup is redundant as
> these directories are suposed to have the machine setup files in
> them.

The *-setup.c is the existing naming sheme used for the Orion and 
Kirkwood architectures to contain board setup code instead of common IRQ 
or timer code for example.  So it is fine.


Nicolas
