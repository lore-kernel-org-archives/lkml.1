Return-Path: <linux-kernel-owner+w=401wt.eu-S1763721AbZEAPp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbZEAPp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbZEAPpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:45:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:34896 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbZEAPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:45:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,279,1239001200"; 
   d="scan'208";a="408660248"
Date: Fri, 1 May 2009 17:48:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: remove driver_data direct access of struct device
Message-ID: <20090501154758.GA7141@sortiz.org>
References: <20090430221850.GA18541@kroah.com> <20090501112525.GD6975@sirena.org.uk> <20090501151535.GC16106@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501151535.GC16106@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, May 01, 2009 at 08:15:35AM -0700, Greg KH wrote:
> On Fri, May 01, 2009 at 12:25:25PM +0100, Mark Brown wrote:
> > On Thu, Apr 30, 2009 at 03:18:50PM -0700, Greg Kroah-Hartman wrote:
> > > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > > In the near future, the driver core is going to not allow direct access
> > > to the driver_data pointer in struct device.  Instead, the functions
> > > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > > have been around since the beginning, so are backwards compatible with
> > > all older kernel versions.
> > 
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > For wm8400:
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Thanks.  Do you mind if I take this in my tree?  Or is there a mfd tree
> somewhere that it should go through?
It should probably go through the mfd tree, I'll take it.

Thanks,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
