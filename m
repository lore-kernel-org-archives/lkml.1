Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZHMLTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZHMLTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZHMLTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:19:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:47163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZHMLTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:19:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,374,1246863600"; 
   d="scan'208";a="540990216"
Date: Thu, 13 Aug 2009 13:21:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 5/5] [regulator] Add a Freescale MC13783 regulator
	driver
Message-ID: <20090813112117.GC3310@sortiz.org>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-5-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-6-git-send-email-s.hauer@pengutronix.de> <1250161026.6407.119.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250161026.6407.119.camel@odin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:57:06AM +0100, Liam Girdwood wrote:
> On Wed, 2009-08-12 at 17:05 +0200, Sascha Hauer wrote:
> > This driver provides basic support for the voltage regulators
> > integrated into the Freescale MC13783 PMIC. It is currently
> > only possible to enable/disable outputs, not to actually
> > set the voltage.
> > 
> > changes since v1:
> > 
> > - decrease verbosity
> > - use subsys_initcall instead of module_init
> > - use platform_driver_probe instead of platform_driver_register
> > - add __devexit_p to mc13783_regulator_remove
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > ---
> >  drivers/regulator/Kconfig   |    8 +
> >  drivers/regulator/Makefile  |    1 +
> >  drivers/regulator/mc13783.c |  410 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 419 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/regulator/mc13783.c
> > 
> 
> Sascha, I'm happy for this to go via Samuel's mfd tree as it makes life
> easier for linux-next and merging.
> 
> Samuel, this ok with you ?
Yes, that's fine. Do we have your SOB there ?

Cheers,
Samuel.

 
> Thanks
> 
> Liam
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
