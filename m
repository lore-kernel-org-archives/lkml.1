Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZECV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZECV5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZECV50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:57:26 -0400
Received: from mga05.intel.com ([192.55.52.89]:1993 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755856AbZECV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,288,1239001200"; 
   d="scan'208";a="453734490"
Date: Sun, 3 May 2009 23:59:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: remove driver_data direct access of struct device
Message-ID: <20090503215940.GD3278@sortiz.org>
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
I applied this one to my for-next branch.
When do you plan to remove the direct driver_data direct access ? I'm asking
to know if I should schedule this patch for sometimes earlier than the next
merge window.

Cheers,
Samuel.

> greg k-h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
