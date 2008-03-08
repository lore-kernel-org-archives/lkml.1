Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYCHGMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYCHGMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 01:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYCHGMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 01:12:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57489 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYCHGMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 01:12:24 -0500
Date: Fri, 7 Mar 2008 21:52:21 -0800
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [UPDATED v3][PATCH 5/7] regulator: sysfs ABI
Message-ID: <20080308055221.GA13434@kroah.com>
References: <1204827125.15360.151.camel@a10323.wolfsonmicro.main> <20080307161212.GD28439@kroah.com> <20080307211714.GA26534@sirena.org.uk> <200803071717.44028.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803071717.44028.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 05:17:43PM -0800, David Brownell wrote:
> On Friday 07 March 2008, Mark Brown wrote:
> > On Fri, Mar 07, 2008 at 08:12:12AM -0800, Greg KH wrote:
> > > On Thu, Mar 06, 2008 at 06:12:05PM +0000, Liam Girdwood wrote:
> > 
> > > > +		Some regulator directories will contain a link called parent.
> > > > +		This points to the parent or supply regulator if one exists.
> > 
> > > I don't think this is needed, why not just parent the device properly in
> > > the device tree itself?
> > 
> > The device tree would tend to show parent for the the control interfaces
> > for the regulators (typically I2C or SPI) but there is likely to be
> > little or no relationship between that and the power distribution in the
> > system.
> 
> I find "parent" a bit awkward, and Greg won't be the only one to
> be asking that question.  Maybe it'd be better named "supply"?

Yes, "parent" means something in the driver model (the parent of the
device in the tree).  I agree with the different wording like "supply"
if that makes sense.  Or something else other than "parent".

thanks,

greg k-h
