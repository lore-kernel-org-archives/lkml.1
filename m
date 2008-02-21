Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbYBUQ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbYBUQ0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbYBUQ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:26:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51054 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757028AbYBUQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:26:33 -0500
Subject: Re: [UPDATED v2][PATCH 0/6] regulator: voltage and current
	regulator framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20080221084128.GA4931@flint.arm.linux.org.uk>
References: <1203527326.4071.88.camel@localhost.localdomain>
	 <20080221084128.GA4931@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 16:26:30 +0000
Message-Id: <1203611191.4071.186.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 08:41 +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 20, 2008 at 05:08:46PM +0000, Liam Girdwood wrote:
> > This patch series provides a generic framework to allow device drivers
> > to control voltage and current regulators on SoC based devices (e.g.
> > phones, gps, media players).
> 
> Note that I'm explicitly avoiding commenting on this as far as PXA3xx
> devices go, until we're further down the road with PM support on that
> SoC.  It's not clear at present whether a generic PMIC framework will
> be suitable for this SoC since it's my understanding from Marvell that
> we need to talk to the PMIC from IRQs-off contexts.
> 
> So don't take my silence as some sort of acceptance of this code; it
> isn't.

I wasn't ;)

It then might be worth adding this functionality at a later stage when
more can be said about PXA3xx PMIC support. We could always have a
version of the _set() functions that are designed to handle this case.

In the mean time this works well on 3 other SoC CPUs.

Liam

