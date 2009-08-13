Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZHMLqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZHMLqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZHMLqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:46:51 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55203 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZHMLqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:46:51 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 07:46:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l43DAW7pKzoPv2Ktzw0u8IXnbJd4vPwoprH3PR9TI9Gw8LNdcQSWKOvN8tXFimW0Rf
         jIU4CAdYXB4+ZtFu2rZadJcNOJBBLKQMl5OGUv7YK164ACL/SyZ+21ihqkvORdc65lfj
         V12k/JnSHK8d4TbdqcPO+wFy5bVp37xZA31Qg=
Subject: Re: [PATCH 5/5] [regulator] Add a Freescale MC13783 regulator
 driver
From: Liam Girdwood <lrg@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090813112117.GC3310@sortiz.org>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-5-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-6-git-send-email-s.hauer@pengutronix.de>
	 <1250161026.6407.119.camel@odin>  <20090813112117.GC3310@sortiz.org>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 12:38:48 +0100
Message-Id: <1250163528.6407.162.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 13:21 +0200, Samuel Ortiz wrote:
> On Thu, Aug 13, 2009 at 11:57:06AM +0100, Liam Girdwood wrote:
> > On Wed, 2009-08-12 at 17:05 +0200, Sascha Hauer wrote:
> > > This driver provides basic support for the voltage regulators
> > > integrated into the Freescale MC13783 PMIC. It is currently
> > > only possible to enable/disable outputs, not to actually
> > > set the voltage.
> > > 
> > > changes since v1:
> > > 
> > > - decrease verbosity
> > > - use subsys_initcall instead of module_init
> > > - use platform_driver_probe instead of platform_driver_register
> > > - add __devexit_p to mc13783_regulator_remove
> > > 
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > > ---
> > >  drivers/regulator/Kconfig   |    8 +
> > >  drivers/regulator/Makefile  |    1 +
> > >  drivers/regulator/mc13783.c |  410 +++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 419 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/regulator/mc13783.c
> > > 
> > 
> > Sascha, I'm happy for this to go via Samuel's mfd tree as it makes life
> > easier for linux-next and merging.
> > 
> > Samuel, this ok with you ?
> Yes, that's fine. Do we have your SOB there ?
> 

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>

Yes, sorry should have added that.

Thanks

Liam

