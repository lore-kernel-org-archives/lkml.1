Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYIJTiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYIJTiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYIJTiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:38:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:52283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYIJTiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:38:10 -0400
Subject: Re: [PATCH 1/2] mfd: Core support for the WM8400 AudioPlus HiFi
	CODEC and PMU
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080910191335.GA26985@rakim.wolfsonmicro.main>
References: <20080910182825.GB16721@rakim.wolfsonmicro.main>
	 <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1221072422.17091.253.camel@odin>
	 <20080910191335.GA26985@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 20:38:04 +0100
Message-Id: <1221075484.17091.258.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 20:13 +0100, Mark Brown wrote:
> On Wed, Sep 10, 2008 at 07:47:01PM +0100, Liam Girdwood wrote:
> > On Wed, 2008-09-10 at 19:28 +0100, Mark Brown wrote:

> > > +EXPORT_SYMBOL_GPL(wm8400_notify_codec_reset);
> > > +
> 
> > I would probably rename this since it's really resetting the codec cache
> > and not resetting the codec.
> 
> The notify in the name was supposed to cover that (implying that it's
> notifying the core rather than actually doing the reset) but it's
> obviously not doing the job.  I think wm8400_reset_codec_reg_cache()
> should be obvious enough?
> 

Sounds good.

> > Fwiw, I've separated out the different wm8350 functions into separate
> > headers - Imho, It just makes it a little easier to read.
> 
> Yeah, I considered doing that but decided that it was more trouble than
> it was worth - the device has far fewer functions than the WM8350.

Wouldn't splitting out audio from power at least half the size of the
header. Imho probably making it easier to track down definitions per
function.

Liam

