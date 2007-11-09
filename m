Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXKIMJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXKIMJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXKIMJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:09:22 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:32794 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbXKIMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:09:21 -0500
Subject: Re: Module init call vs symbols exporting race?
From: Jon Masters <jonathan@jonmasters.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200711081310.07697.rusty@rustcorp.com.au>
References: <473031FA.2060707@openvz.org>
	 <200711062341.34566.rusty@rustcorp.com.au>
	 <1194429690.6874.7.camel@localhost.localdomain>
	 <200711081310.07697.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 09 Nov 2007 06:44:00 -0500
Message-Id: <1194608640.9377.104.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-08 at 13:10 +1100, Rusty Russell wrote:
> On Wednesday 07 November 2007 21:01:30 Jan Glauber wrote:
> > Hi Rusty,
> >
> > I've seen a symbol-resolving race on s390. The qeth module uses symbols
> > from qdio and although the loading order seems correct and the qdio
> > symbols should be available the following error appears:
> >
> > qdio: loading QDIO base support version 2
> > qeth: Unknown symbol qdio_synchronize
> 
> Looks like qdio does something which triggers qeth to load, but of course qdio 
> isn't finished initializing yet so its symbols aren't available.
> 
> It's not obvious what's triggering the load, but you could probably find it by 
> using printk's through qdio.c's init_QDIO().

Jan - did you get anything?

Jon.


