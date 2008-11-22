Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbYKVXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbYKVXeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYKVXeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:34:13 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:57229 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYKVXeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:34:12 -0500
Date: Sun, 23 Nov 2008 00:33:56 +0100
From: Stefan Schmidt <stefan@openmoko.org>
To: David Brownell <david-b@pacbell.net>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, spi-devel-general@lists.sourceforge.net,
       eric.y.miao@gmail.com, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Message-ID: <20081122233356.GC24437@datenfreihafen.org>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811212125.49068.david-b@pacbell.net> <1227373948.19591.66.camel@brutus> <200811221119.27981.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811221119.27981.david-b@pacbell.net>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sat, 2008-11-22 at 11:19, David Brownell wrote:
> On Saturday 22 November 2008, Daniel Ribeiro wrote:
> >  
> > +config EZX_PCAP
> > +       bool "PCAP Support"
> > +       depends on PXA_EZX
> 
> It only builds on one platform.  Now, that may make sense if it's
> an ASIC currently used only on that platform; it's a "hardware"
> dependency.  But it's not a necessary "software" dependency, no
> code here seems to rely on PXA hardware, or EZX hardware.

It is software and we are on the way fixing it.

> One of the goals of getting drivers into mainline is to get rid
> of needless dependencies ... and thereby open the code up to
> many more developers.  Some may do nothing more than cleanup;
> others will be doing API overhauls, which can be a PITA if you
> place needless build dependencies on your code.

Understand. We have been a bit lazy here, sorry. That is mostly based on the
fact that we have never seen any other linux devices having this chip. Only some
low power feature phones with the P2K OS from Motorola. Anyway, we work on it to
get it more generic now.

> Strike that dependency, and depend instead on SPI_MASTER since
> that's the only dependency truly required by the build system.

Will do.

regards
Stefan Schmidt
