Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbZEAPlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbZEAPlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759870AbZEAPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:40:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:37376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759783AbZEAPkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:40:53 -0400
Date: Fri, 1 May 2009 08:15:35 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: remove driver_data direct access of struct device
Message-ID: <20090501151535.GC16106@suse.de>
References: <20090430221850.GA18541@kroah.com> <20090501112525.GD6975@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501112525.GD6975@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 12:25:25PM +0100, Mark Brown wrote:
> On Thu, Apr 30, 2009 at 03:18:50PM -0700, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> > In the near future, the driver core is going to not allow direct access
> > to the driver_data pointer in struct device.  Instead, the functions
> > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > have been around since the beginning, so are backwards compatible with
> > all older kernel versions.
> 
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> For wm8400:
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks.  Do you mind if I take this in my tree?  Or is there a mfd tree
somewhere that it should go through?

greg k-h
