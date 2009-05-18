Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZERU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZERU1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZERU1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:27:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41578 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751422AbZERU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:27:09 -0400
Date: Mon, 18 May 2009 21:28:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 02/13] Driver Core: misc: add nodename support for misc
 devices.
Message-ID: <20090518212801.653c3bf0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090515195856.GD1353@ucw.cz>
References: <20090509142601.874865281@blue.kroah.org>
	<20090509143631.755885703@blue.kroah.org>
	<20090515195856.GD1353@ucw.cz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 21:58:56 +0200
Pavel Machek <pavel@ucw.cz> wrote:

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

More to the point we already have /proc/misc
