Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZERT7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZERT7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZERT7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:59:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZERT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:59:16 -0400
Date: Mon, 18 May 2009 21:59:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 02/13] Driver Core: misc: add nodename support for misc
	devices.
Message-ID: <20090518195908.GB1366@ucw.cz>
References: <20090509142601.874865281@blue.kroah.org> <20090509143631.755885703@blue.kroah.org> <20090515195856.GD1353@ucw.cz> <20090518143406.GB20476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518143406.GB20476@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-18 07:34:06, Greg KH wrote:
> On Fri, May 15, 2009 at 09:58:56PM +0200, Pavel Machek wrote:
> > On Sat 2009-05-09 07:26:03, Greg KH wrote:
> > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > 
> > > This adds support for misc devices to report their requested nodename to
> > > userspace.  It also updates a number of misc drivers to provide the
> > > needed subdirectory and device name to be used for them.
> > > 
> > > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Maybe it would be better to assign stable minor/major numbers to those
> > devices instead? minor/major number space is pretty big these days...
> 
> That's up to the individual misc driver authors.  Lots of them use the
> dynamic option, so it's not like we can just ignore this very common
> feature.

Well, you are willing to submit device names for individual drivers,
so... 

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
