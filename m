Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbZEAPpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbZEAPpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZEAPpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:45:05 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:32970 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZEAPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:45:04 -0400
Subject: Re: [PATCH] regulator: remove driver_data direct access of struct
 device
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Greg KH <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090501152330.GF16106@suse.de>
References: <20090430222137.GA18614@kroah.com>
	 <20090501091928.GA3339@rakim.wolfsonmicro.main>
	 <20090501152330.GF16106@suse.de>
Content-Type: text/plain
Date: Fri, 01 May 2009 16:45:00 +0100
Message-Id: <1241192700.5473.33.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 08:23 -0700, Greg KH wrote:
> On Fri, May 01, 2009 at 10:19:29AM +0100, Mark Brown wrote:
> > On Thu, Apr 30, 2009 at 03:21:37PM -0700, Greg Kroah-Hartman wrote:
> > 
> > > In the near future, the driver core is going to not allow direct access
> > > to the driver_data pointer in struct device.  Instead, the functions
> > > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > > have been around since the beginning, so are backwards compatible with
> > > all older kernel versions.
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Thanks.  Is there a regulator kernel tree that this patch should go
> through, or can I take it through my driver core tree?
> 

I'll apply it to the voltage regulator tree shortly.

Thanks

Liam

