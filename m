Return-Path: <linux-kernel-owner+w=401wt.eu-S1761034AbZENHqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034AbZENHqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbZENHph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:45:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58306 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZENHpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:45:35 -0400
Date: Thu, 14 May 2009 09:45:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Daniel Mack <daniel@caiaq.de>,
       Vladimir Barinov <vbarinov@embeddedalley.com>,
       Linux MTD list <linux-mtd@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: mxc_nand: fix built breakage
Message-ID: <20090514074529.GX29278@pengutronix.de>
References: <1242229410-11853-1-git-send-email-daniel@caiaq.de> <4A0AF0C7.5090104@embeddedalley.com> <20090513161154.GK32424@buzzloop.caiaq.de> <20090514065611.GU29278@pengutronix.de> <1242284479.27996.196.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242284479.27996.196.camel@localhost.localdomain>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:43:36 up 2 days, 22:07, 21 users,  load average: 0.02, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 10:01:19AM +0300, Artem Bityutskiy wrote:
> On Thu, 2009-05-14 at 08:56 +0200, Sascha Hauer wrote:
> > On Wed, May 13, 2009 at 06:11:54PM +0200, Daniel Mack wrote:
> > > On Wed, May 13, 2009 at 08:09:43PM +0400, Vladimir Barinov wrote:
> > > > Please find the patch that I've sent some time ago. This patch should  
> > > > fix the issue you described.
> > > > http://lists.infradead.org/pipermail/linux-mtd/2009-April/025363.html
> > > 
> > > 
> > > Ah, ok, thanks.
> > > 
> > > Did anyone pick it up for mainline already?
> > > Sascha, I didn't see that one in your tree either.
> > 
> > It seems to be pure luck when the patches on the mtd list get picked up.
> > Most of the time I do not even a reaction from the list or David. I
> > wonder if someone will beat me up when I take the i.MX nand patches via
> > my arm tree.
> 
> I've put Vladimir's patch to my l2-mtd-2.6.git tree:
> http://git.infradead.org/users/dedekind/l2-mtd-2.6.git
> 
> which means I'll be pinging David about pulling it. This is all
> I can do for you, unfortunately.

Thanks a lot. I really prefer driver patches going over the according
subsystem tree rather then leaking them in from the architecture tree.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
