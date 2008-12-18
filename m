Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753238AbYLRUrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYLRUrb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYLRUrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:47:21 -0500
Received: from mail.openmoko.org ([88.198.124.205]:46346 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYLRUrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:47:21 -0500
Date: Fri, 19 Dec 2008 02:17:05 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>
Subject: Re: [PATCH V2 7/7] regulator: PCF50633 pmic driver
Message-ID: <20081218204705.GD2284@cff.thadambail>
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055817.31696.67376.stgit@cff.thadambail> <20081218100835.GA27075@rakim.wolfsonmicro.main> <20081218151431.GB2284@cff.thadambail> <1229632254.24727.1394.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229632254.24727.1394.camel@vega.slimlogic.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 08:30:54PM +0000, Liam Girdwood wrote:
> On Thu, 2008-12-18 at 20:44 +0530, Balaji Rao wrote:
> > On Thu, Dec 18, 2008 at 10:08:35AM +0000, Mark Brown wrote:
> > > On Thu, Dec 18, 2008 at 11:28:17AM +0530, Balaji Rao wrote:
> > > > Changes from V1:
> > > > 	- Removed support for suspend_enable & suspend_disable functions.
> > > > 
> > > > Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> > > > Cc: Andy Green <andy@openmoko.com>
> > > > Cc: Liam Girdwood <lrg@simlogic.co.uk>
> 
> Applied.
> 
> Thanks
> 

Liam, the pcf50633-regulator.c has depends on
include/linux/mfd/pcf50633/core.patch which is not here, but in
[PATCH 1/7] of the series. So, pcf50633-regulator.c it wouldn't
build.

I was expecting it to make it to -next via linux-mfd - I've asked
Samuel Ortiz about this in [0/7].

So, I was hoping you to ack this so that Samuel can take it into
linux-mfd.

I apologize for the confusion.

	- Balaji
