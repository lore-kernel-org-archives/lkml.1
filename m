Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYIJT6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYIJT6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYIJT6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:58:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:44076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYIJT6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:58:07 -0400
Subject: Re: [PATCH 2/2] regulator: Add WM8400 regulator support
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080910194048.GB26985@rakim.wolfsonmicro.main>
References: <20080910182825.GB16721@rakim.wolfsonmicro.main>
	 <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1221071334-19381-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1221071968.17091.245.camel@odin>
	 <20080910194048.GB26985@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 20:58:00 +0100
Message-Id: <1221076680.17091.259.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 20:40 +0100, Mark Brown wrote:
> On Wed, Sep 10, 2008 at 07:39:28PM +0100, Liam Girdwood wrote:
> 
> > > +static unsigned int wm8400_dcdc_get_optimum_mode(struct regulator_dev *dev,
> > > +						 int input_uV, int output_uV,
> > > +						 int load_uA)
> > > +{
> > > +	return REGULATOR_MODE_IDLE;
> > > +}
> > > +
> 
> > This should return NORMAL by default. Probably best to add a lookup
> > table for IDLE & STANDBY if supported.
> 
> Yeah, I've changed it to NORMAL for now.  I'll add the lookup table in a
> followup patch later along with things like support for configuring the
> suspend modes of the device if that's OK?

OK by me.

Thanks

Liam

