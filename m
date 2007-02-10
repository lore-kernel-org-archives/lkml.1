Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbXBJKTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbXBJKTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXBJKTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:19:23 -0500
Received: from ozlabs.org ([203.10.76.45]:45429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbXBJKTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:19:22 -0500
Subject: Re: force insmod on 2.6
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Leisner, Martin" <Martin.Leisner@xerox.com>
Cc: linux-kernel@vger.kernel.org, leisner@rochester.rr.com
In-Reply-To: <556445368AFA1C438794ABDA8901891C034456F2@usa0300ms03.na.xerox.net>
References: <556445368AFA1C438794ABDA8901891C034456F2@usa0300ms03.na.xerox.net>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 21:18:30 +1100
Message-Id: <1171102710.15356.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 12:27 -0500, Leisner, Martin wrote:
> I had modules which were compiled with another kernel version string
> (same kernel though).
> 
> In 2.4, you could do a force in the modules.conf files or in the insmod
> command line.
> 
> The current insmod doesn't have a force option.
> 
> Modprobe CAN force, but the modules has to be in the modules tree (i.e.
> not arbitrary places on the 
> file system)
> 
> Is there a way to force load a module at an arbitrary location?
> 
> This is very handy for development (not production).

Sure, you simply remove the information from the module, then the kernel
will load it.  To strip modversions, remove the __versions section.  To
strip the version magic, it's easiest to remove the entire .modinfo
section.  You can use objcopy for this...

Hope that helps!
Rusty.

