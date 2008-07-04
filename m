Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYGDJSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYGDJSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYGDJSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:18:45 -0400
Received: from smtp.wifcom.cz ([89.185.251.8]:43221 "EHLO wifcom.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbYGDJSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:18:45 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2008 05:18:45 EDT
Date: Fri, 4 Jul 2008 10:44:24 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
	clocks.
Message-ID: <20080704084424.GA4531@elf.ucw.cz>
References: <20080626125033.GA7093@doriath.ww600.siemens.net> <20080626125138.GA12415@doriath.ww600.siemens.net> <20080703203157.GB24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703203157.GB24620@fluff.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-03 21:31:57, Ben Dooks wrote:
> On Thu, Jun 26, 2008 at 04:51:38PM +0400, Dmitry Baryshkov wrote:
> > Provide a generic framework that platform may choose
> > to support clocks api. In particular this provides
> > platform-independant struct clk definition, a full
> > implementation of clocks api and a set of functions
> > for registering and unregistering clocks in a safe way.
> > 
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > ---
> >  include/linux/clocklib.h |   58 ++++++++
> >  lib/Kconfig              |    3 +
> >  lib/Makefile             |    1 +
> >  lib/clocklib.c           |  353 ++++++++++++++++++++++++++++++++++++++++++++++
> 
> why under lib? drivers/clk might be a better place for this.

This does not belong into lib/, really. drivers/clk seems ok.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
