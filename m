Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbZJNBxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbZJNBxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbZJNBxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:53:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:45564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757454AbZJNBxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:53:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/WaOcxgsDWjLsdxXLK0DkV4vpN+kx+d76vzlHLpO
	SQVXNEETP+SZjI
Subject: Re: Current status of rt2800usb and staging/rt2870
From: Mike Galbraith <efault@gmx.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200910132121.25743.bzolnier@gmail.com>
References: <4AD46380.9020308@pardus.org.tr>
	 <200910131927.24136.bzolnier@gmail.com>
	 <200910132017.47748.IvDoorn@gmail.com>
	 <200910132121.25743.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 03:52:55 +0200
Message-Id: <1255485175.7115.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 21:21 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 13 October 2009 20:17:47 Ivo van Doorn wrote:
> > On Tuesday 13 October 2009, Bartlomiej Zolnierkiewicz wrote:
> > > On Tuesday 13 October 2009 17:52:52 Ivo van Doorn wrote:
> > > 
> > > > I am going to merge rt2800pci soon as well and after that I'll send a patch
> > > 
> > > Great, I've been waiting for this for a long time.
> > > 
> > > > to remove all Ralink drivers from the staging tree.
> > > 
> > > Till new drivers obtain support for all hardware currently covered by
> > > the unified staging drivers the latter shouldn't be removed as they
> > > serve well their role as a temporary solution allowing real Linux users
> > > to user their real hardware and as a reference material for developers
> > > willing to work on adding the missing bits to new drivers.
> > 
> > The rt2800pci and rt2800usb drivers cover support for rt2860/rt2870/rt3070 devices,
> > which are present as individual drivers in the staging tree. So far it only managed
> 
> There are no longer individual drivers.
> 
> Instead there is one shared source code and two device drivers:
> 
> - rt2860 covering RT2860 and RT3090 devices
> 
> - rt2870 covering RT2870 and RT3070 devices
> 
> In comparison rt2800usb currently lacks RT3070 support and rt2800pci's
> RT3090 support is basic at best (not to mention that it didn't work for
> RT2860 last time that I tried)..

(or RT2870 here)

