Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbXI0XGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbXI0XGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbXI0XGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:06:45 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:50390 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXI0XGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:06:45 -0400
Subject: Re: [Bluez-devel] Warnings and Bug on 2.6.23-rc6 closing rfcomm
	links (device_move() API ?)
From: Marcel Holtmann <marcel@holtmann.org>
To: BlueZ development <bluez-devel@lists.sourceforge.net>
Cc: Pierre-Yves Paulus <py@idlum.be>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       BlueZ@sc8-sf-spam2-b.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070927154804.17487b20@gondolin.boeblingen.de.ibm.com>
References: <46F92586.5070402@idlum.be> <200709271429.09910.rjw@sisk.pl>
	 <46FBA4A7.70200@idlum.be>
	 <20070927154804.17487b20@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 01:04:51 +0200
Message-Id: <1190934291.6484.76.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cornelia,

> > >> Yet another report, once again while putting rfcomm system under load. 
> > >> Several USB adapters, several links.
> > > 
> > > Is this a regression or does it happen with 2.6.22 too?
> > 
> > I've not tested with 2.6.22, but have done it a few days ago with 
> > 2.6.21-2-486 (stock debian package), and got the 2 Oops below. Maybe 
> > that's a different problem, or maybe not?
> > 
> > 
> > kobject_add failed for rfcomm1 with -EEXIST, don't try to register 
> > things with the same name in the same directory.
> 
> There's something wrong with rfcomm trying to create objects with
> duplicate names...

that should have been fixed.

Regards

Marcel


