Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZKKOaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZKKOaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZKKOaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:30:15 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33349 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZKKOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:30:14 -0500
Subject: Re: [PATCH 2/2] regulator/mc13783: various cleanups
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20091111141623.GB1849@pengutronix.de>
References: <20091106002847.GC22366@sortiz.org>
	 <1257841087-23662-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1257841087-23662-2-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1257948708.3089.101.camel@odin>  <20091111141623.GB1849@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 14:30:07 +0000
Message-ID: <1257949807.3089.127.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 15:16 +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Nov 11, 2009 at 02:11:48PM +0000, Liam Girdwood wrote:
> > On Tue, 2009-11-10 at 09:18 +0100, Uwe Kleine-König wrote:
> > > - define needed registers and bits in the driver
> > > - properly namespace functions and structs
> > > - fix locking as required by patch
> > >   "mfd/mc13783: near complete rewrite"
> > > - use platform_data as provided by "mfd/mc13783: near complete rewrite"
> > >   instead of accessing struct mc13783
> > > - struct mc13783_regulator_priv.desc is (and was) unused and so can go
> > >   away
> > > - use cpp magic to initialize mc13783_regulators
> > > - bring MODULE_LICENSE in sync with actual copyright
> > > - minor style fixes
> > > 
> > > This allows not including mc13783-private.h which I intend to remove
> > > soon.
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > ---
> > 
> > I assume the new mc13783 function and type definitions are in mfd-next ?
> Yes, it's 3a69e7d9f6b1fb6c6db7f23e22351e3db7d55ebb in todays linux-next.
>  

Applied

Thanks.

Liam

