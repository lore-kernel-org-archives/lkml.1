Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYKWAdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYKWAdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 19:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYKWAdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 19:33:16 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:43416 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbYKWAdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 19:33:16 -0500
Date: Sun, 23 Nov 2008 01:33:06 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: David Brownell <david-b@pacbell.net>
Cc: Stefan Schmidt <stefan@openmoko.org>,
       spi-devel-general@lists.sourceforge.net, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>
Message-ID: <20081123003306.GE24437@datenfreihafen.org>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811221119.27981.david-b@pacbell.net> <20081122233356.GC24437@datenfreihafen.org> <200811221558.03915.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811221558.03915.david-b@pacbell.net>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 15:58, David Brownell wrote:
> On Saturday 22 November 2008, Stefan Schmidt wrote:
> > > > +config EZX_PCAP
> > > > +       bool "PCAP Support"
> > > > +       depends on PXA_EZX
> > > 
> > > It only builds on one platform.  Now, that may make sense if it's
> > > an ASIC currently used only on that platform; it's a "hardware"
> > > dependency.  But it's not a necessary "software" dependency, no
> > > code here seems to rely on PXA hardware, or EZX hardware.
> > 
> > It is software and we are on the way fixing it.
> 
> Good.  I've only seen patch #5 of this series, so I couldn't
> tell what else was up.

Sorry. This set touched a lot of different subsystems. (ARM, spi, rtc, input,
mfd, ..) The To: and Cc: list gave me quite some headache. :) Next time I make
sure that at least LKML is cc'ed on the whle series so people have a lace to
look at it in one thread.

> > Understand. We have been a bit lazy here, sorry. That is mostly based on the
> > fact that we have never seen any other linux devices having this chip. Only some
> > low power feature phones with the P2K OS from Motorola. Anyway, we work on it to
> > get it more generic now.
> 
> Looks to me like you're almost all the way there already!  :)

We hope so, yes. :) Once we have the EZX/PXA dep gone you are fine with this
patch? All SPI related stuff is ok from you?

> Much like we're doing with the twl4030 family chips ... they're
> used on a lot of OMAP3 (and some OMAP2430) boards, and some
> build dependencies evolved over the past year or so while
> the driver support was maturing out of mainline.

Yeah, pretty similar. We had to start from 2.4 driver code to get in touch with
this chip. Motorola did not offer any docs. Also the usual embedded board
out-of-tree problem. We are doing a lot better now since the last two kernels
though. Better workflow, tools, faster reaction on review and more energy
towards upstream submissions.

regards
Stefan Schmidt
