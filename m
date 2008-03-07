Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbYCGVRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbYCGVRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYCGVRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:17:23 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3884 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760086AbYCGVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:17:23 -0500
Date: Fri, 7 Mar 2008 21:17:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [UPDATED v3][PATCH 5/7] regulator: sysfs ABI
Message-ID: <20080307211714.GA26534@sirena.org.uk>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827125.15360.151.camel@a10323.wolfsonmicro.main> <20080307161212.GD28439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307161212.GD28439@kroah.com>
X-Cookie: 15% gratuity added for parties over 8.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 08:12:12AM -0800, Greg KH wrote:
> On Thu, Mar 06, 2008 at 06:12:05PM +0000, Liam Girdwood wrote:

> > +		Some regulator directories will contain a link called parent.
> > +		This points to the parent or supply regulator if one exists.

> I don't think this is needed, why not just parent the device properly in
> the device tree itself?

The device tree would tend to show parent for the the control interfaces
for the regulators (typically I2C or SPI) but there is likely to be
little or no relationship between that and the power distribution in the
system.
