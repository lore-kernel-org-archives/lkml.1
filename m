Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZEROeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZEROeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZEROeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:34:15 -0400
Received: from kroah.org ([198.145.64.141]:43996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZEROeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:34:14 -0400
Date: Mon, 18 May 2009 07:34:06 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 02/13] Driver Core: misc: add nodename support for misc
	devices.
Message-ID: <20090518143406.GB20476@kroah.com>
References: <20090509142601.874865281@blue.kroah.org> <20090509143631.755885703@blue.kroah.org> <20090515195856.GD1353@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515195856.GD1353@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 09:58:56PM +0200, Pavel Machek wrote:
> On Sat 2009-05-09 07:26:03, Greg KH wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > 
> > This adds support for misc devices to report their requested nodename to
> > userspace.  It also updates a number of misc drivers to provide the
> > needed subdirectory and device name to be used for them.
> > 
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Maybe it would be better to assign stable minor/major numbers to those
> devices instead? minor/major number space is pretty big these days...

That's up to the individual misc driver authors.  Lots of them use the
dynamic option, so it's not like we can just ignore this very common
feature.

thanks,

greg k-h
