Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYIJTk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYIJTk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIJTku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:40:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52540 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751928AbYIJTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:40:50 -0400
Date: Wed, 10 Sep 2008 20:40:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: Add WM8400 regulator support
Message-ID: <20080910194048.GB26985@rakim.wolfsonmicro.main>
Mail-Followup-To: Liam Girdwood <lrg@kernel.org>,
	Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
References: <20080910182825.GB16721@rakim.wolfsonmicro.main> <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1221071334-19381-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1221071968.17091.245.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221071968.17091.245.camel@odin>
X-Cookie: Whip it, whip it good!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 07:39:28PM +0100, Liam Girdwood wrote:

> > +static unsigned int wm8400_dcdc_get_optimum_mode(struct regulator_dev *dev,
> > +						 int input_uV, int output_uV,
> > +						 int load_uA)
> > +{
> > +	return REGULATOR_MODE_IDLE;
> > +}
> > +

> This should return NORMAL by default. Probably best to add a lookup
> table for IDLE & STANDBY if supported.

Yeah, I've changed it to NORMAL for now.  I'll add the lookup table in a
followup patch later along with things like support for configuring the
suspend modes of the device if that's OK?
