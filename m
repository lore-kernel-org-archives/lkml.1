Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYBXKYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYBXKYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYBXKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:24:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2525 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYBXKX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:23:56 -0500
Date: Sun, 24 Feb 2008 10:23:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/6] regulator: regulator core.
Message-ID: <20080224102348.GA11156@sirena.org.uk>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1203527351.4071.92.camel@localhost.localdomain> <20080223000538.e1f086e1.akpm@linux-foundation.org> <20080223095217.GA28356@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223095217.GA28356@flint.arm.linux.org.uk>
X-Cookie: The other line moves faster.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 09:52:17AM +0000, Russell King - ARM Linux wrote:
> On Sat, Feb 23, 2008 at 12:05:38AM -0800, Andrew Morton wrote:

> > > +#undef current

> > err, no ;)  Please rename your stuff.

> Renaming is not an option - "current" is an electronic term for which
> there is no alternative.  The real problem is this __ATTR macro crap:

Indeed, and this is already being worked around by
drivers/power/power_supply_sysfs.c:

#define POWER_SUPPLY_ATTR(_name)                                        \
{                                                                       \
        .attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE }, \
        .show = power_supply_show_property,                             \
        .store = NULL,                                                  \
}
