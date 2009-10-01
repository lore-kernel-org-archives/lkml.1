Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZJAPZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZJAPZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZJAPZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:25:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:20108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbZJAPZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,488,1249282800"; 
   d="scan'208";a="555746803"
Date: Thu, 1 Oct 2009 17:27:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] power_supply: Factor out WM831x backup battery
 charger
Message-ID: <20091001152746.GG10199@sortiz.org>
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20091001145500.GA21973@oksana.dev.rtsoft.ru>
 <20091001150330.GA16177@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001150330.GA16177@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 04:03:31PM +0100, Mark Brown wrote:
> On Thu, Oct 01, 2009 at 06:55:00PM +0400, Anton Vorontsov wrote:
> 
> > Looks good. Should I apply it, or it depends on 1/4 and 2/4?
> 
> There should be no build time dependency so you should be able to apply
> it.  It'd mean that the WM8320 won't get the backup battery charger
> instantiating until it's merged with the power tree but that's not a
> terribly big deal and it would avoid the possibility of any merge issues
> from a colliding Makefile/Kconfig change in drivers/power.
> 
> Samuel, do you have any preferences?
I'm fine with Anton taking it if that makes everyone's life easier.
Anton, you can add my Acked-by for the mfd part, if you think that's
necessary.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
