Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXHQGZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXHQGZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758285AbXHQGZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:25:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223AbXHQGZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:25:06 -0400
Message-ID: <46C53F3F.5060108@redhat.com>
Date: Fri, 17 Aug 2007 02:25:03 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFHelp:  Splitting MAINTAINERS into maintainers/* and	Makefile/Kconfig
 support
References: <1187297496.5906.113.camel@localhost>
In-Reply-To: <1187297496.5906.113.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> I've got a tree with a directory full of separate
> MAINTAINER blocks that looks like:
> 
> 00_file_description
> 3c359_network_driver
> 3c505_network_driver
> 3c59x_network_driver
> 3cr990_network_driver
> ...
> zd1211rw_wireless_driver
> zf_machz_watchdog
> zr36067_video_for_linux_driver
> zs_decstation_z85c30_serial_driver
> zz_the_rest
> 
> A little more than 600 files

NO.  PLEASE!

The whole point of MAINTAINERS is to have one central repository for this 
information, instead of scattering it throughout the various source files.  If 
that file is getting too unwieldy (and I don't think it is) then I could 
understand splitting it up hierarchically, for example having a 
drivers/net/MAINTAINERS that listed the info for all the net drivers.

What you're suggesting is a less efficient equivalent to putting the info 
directly into the source files.  If that approach was enough to make people 
happy, we wouldn't have MAINTAINERS to begin with.  Perhaps with a little 
automation it could be revived, though I think that adding a path pattern 
removes the need, while keeping it easier to parse by scripts.

I appreciate the effort to make MAINTAINERS more useful, but please don't add 
another 600 files to the tree.

	-- Chris
