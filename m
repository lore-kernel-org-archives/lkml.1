Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXJBPAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXJBPAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJBPAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:00:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35269 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbXJBPAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:00:41 -0400
Date: Tue, 2 Oct 2007 17:02:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch] menuconfig - lift the fs menu
Message-ID: <20071002150210.GB3567@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0710021549421.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710021549421.7130@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 03:51:55PM +0200, Jan Engelhardt wrote:
> 
> Lift the FS menu a bit by moving filesystem-specific
> parts into their own menu.
> 
> This also moves minix and romfs into the "misc fs" menu,
> as per Randy Dunlap's suggestion [http://lkml.org/lkml/2007/9/25/344]

I for one would much rather see a distributed approach used here.
So all filesystem Kconfig bits move to their respective filesystems.

And then on top of that or in same process reorganize the menus a bit.

We did this with success for networking a year or so ago.

	Sam
