Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbZEAPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbZEAPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762033AbZEAPlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:41:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160AbZEAPlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:41:05 -0400
Date: Fri, 1 May 2009 08:23:30 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: remove driver_data direct access of struct
	device
Message-ID: <20090501152330.GF16106@suse.de>
References: <20090430222137.GA18614@kroah.com> <20090501091928.GA3339@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501091928.GA3339@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 10:19:29AM +0100, Mark Brown wrote:
> On Thu, Apr 30, 2009 at 03:21:37PM -0700, Greg Kroah-Hartman wrote:
> 
> > In the near future, the driver core is going to not allow direct access
> > to the driver_data pointer in struct device.  Instead, the functions
> > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > have been around since the beginning, so are backwards compatible with
> > all older kernel versions.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks.  Is there a regulator kernel tree that this patch should go
through, or can I take it through my driver core tree?

thanks,

greg k-h
