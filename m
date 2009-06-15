Return-Path: <linux-kernel-owner+w=401wt.eu-S1761313AbZFOOmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313AbZFOOmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZFOOm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:42:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:62865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZFOOm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:42:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="421958507"
Date: Mon, 15 Jun 2009 16:44:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, eric miao <eric.y.miao@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/da903x: initialize PMIC core early
Message-ID: <20090615144434.GD4094@sortiz.org>
References: <4A363841.5090406@compulab.co.il> <20090615135117.GC4094@sortiz.org> <4A3655DC.9090407@compulab.co.il> <20090615143410.GE6106@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615143410.GE6106@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:34:11PM +0100, Mark Brown wrote:
> On Mon, Jun 15, 2009 at 05:08:28PM +0300, Mike Rapoport wrote:
> > Samuel Ortiz wrote:
> 
> > > Sure. Care to explain why this needs to be called earlier ?
> 
> > We want to have da903x regulators available early during boot, and since they
> > are subdevices of mfd/da903x they cannot be enabled until the da903x core is
> > initialized.
> > I just saw Liam Girdwood pull request with "regulator: Move regulator drivers to
> > subsys_initcall()" commit and jumped in :)
> 
> Any MFD core with regulators on it ought to be pulled forward to
> subsys_initcall().  Doing this makes it easier to get a sensible
> ordering during boot without having a song and dance in consumer
> drivers waiting for the regulators that supply them to instantiate.
Yep, I'm preparing a patch for that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
