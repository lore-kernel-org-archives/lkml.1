Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbZGWImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbZGWImX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZGWImW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:42:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54154 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752053AbZGWImW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:42:22 -0400
Date: Thu, 23 Jul 2009 09:42:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] regulator: Provide mode to status conversion
 function
Message-ID: <20090723084221.GB5744@rakim.wolfsonmicro.main>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248295288.25964.844.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248295288.25964.844.camel@vega.slimlogic.co.uk>
X-Cookie: <wiggy> bwah, vodka in my mouse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:41:28PM +0100, Liam Girdwood wrote:
> On Tue, 2009-07-21 at 16:00 +0100, Mark Brown wrote:

> > +int regulator_mode_to_status(unsigned int);
> > +
> >  void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);

> I've applied all patches, but I'm wondering whether it would be better
> to eventually merge MODE and STATUS. i.e. have REGULATOR_FAST instead of
> REGULATOR_STATUS_FAST and REGULATOR_MODE_FAST. 

I agree, at least lining up the values so you can just assign between
the two would be nice.
