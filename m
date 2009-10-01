Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZJAPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZJAPaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZJAPaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:30:30 -0400
Received: from ru.mvista.com ([213.79.90.228]:15234 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752708AbZJAPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:30:29 -0400
Date: Thu, 1 Oct 2009 19:30:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] power_supply: Factor out WM831x backup battery
 charger
Message-ID: <20091001153031.GA27749@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20091001145500.GA21973@oksana.dev.rtsoft.ru>
 <20091001150330.GA16177@rakim.wolfsonmicro.main>
 <20091001152746.GG10199@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091001152746.GG10199@sortiz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 05:27:47PM +0200, Samuel Ortiz wrote:
> On Thu, Oct 01, 2009 at 04:03:31PM +0100, Mark Brown wrote:
> > On Thu, Oct 01, 2009 at 06:55:00PM +0400, Anton Vorontsov wrote:
> > 
> > > Looks good. Should I apply it, or it depends on 1/4 and 2/4?
> > 
> > There should be no build time dependency so you should be able to apply
> > it.  It'd mean that the WM8320 won't get the backup battery charger
> > instantiating until it's merged with the power tree but that's not a
> > terribly big deal and it would avoid the possibility of any merge issues
> > from a colliding Makefile/Kconfig change in drivers/power.
> > 
> > Samuel, do you have any preferences?
> I'm fine with Anton taking it if that makes everyone's life easier.
> Anton, you can add my Acked-by for the mfd part, if you think that's
> necessary.

Great, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
