Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXINOee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXINOee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXINOeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:34:24 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46604 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXINOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:34:24 -0400
Date: Fri, 14 Sep 2007 04:27:14 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver core: remove get_bus()
Message-ID: <20070914112714.GA22349@kroah.com>
References: <20070913233751.GA10856@kroah.com> <20070913233850.GB10856@kroah.com> <20070914130207.0c22c8a6@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914130207.0c22c8a6@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 01:02:07PM +0200, Cornelia Huck wrote:
> On Thu, 13 Sep 2007 16:38:50 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> > get_bus() should not be globally visable as it is not used by anything
> > other than drivers/base/bus.c.  This patch removes the visability of it,
> 
> Makes sense.
> 
> > and renames it to match all of the other *_get() functions in the
> > kernel.
> 
> What about get_device() and get_driver()? (Not that I want to change
> those, but I think the driver core should stick to one naming
> convention.)

Yes, we should stick to one convention, that's why I made these changes.
Also they were self-contained, as you mention, it would be much harder
to change get_device :(

thanks,

greg k-h
