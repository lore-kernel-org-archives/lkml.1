Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYG1WRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYG1WRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYG1WR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:17:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39801 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYG1WR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:17:26 -0400
Date: Mon, 28 Jul 2008 15:14:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
Message-Id: <20080728151441.03410ecd.randy.dunlap@oracle.com>
In-Reply-To: <1217282540.22927.13.camel@zem.phub.net.cable.rogers.com>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
	<20080726094718.b617c1e7.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
	<1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
	<alpine.LFD.1.10.0807280531210.3402@localhost.localdomain>
	<20080728103731.7bafd577.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807281437070.10586@localhost.localdomain>
	<1217282540.22927.13.camel@zem.phub.net.cable.rogers.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 18:02:20 -0400 Calvin Walton wrote:

> On Mon, 2008-07-28 at 14:42 -0400, Robert P. J. Day wrote:
> > On Mon, 28 Jul 2008, Randy Dunlap wrote:
> > it strikes me that, at least on x86, MSDOS partition support is so
> > fundamental that it should take work for someone to turn it *off*.
> > perhaps simply have it on by default, and force someone to go under
> > "Configure standard kernel features (for small systems)"
> > (CONFIG_EMBEDDED) to make it go away?
> > 
> >   seriously, how often is someone going to build a kernel for x86 and
> > not need MSDOS partition support?  just curious.
> > 
> > rday
> 
> Naturally, on an architecture other than x86 (e.g. sparc) you'll want to
> ensure that the platform's native partitioning format (for sparc,
> SUN_PARTITION) is similarly on by default, and difficult to unselect. 
> 
> In this case, you could get by perfectly without msdos partitions
> enabled (although the default is still to enable them), unless you want
> to read a usb key or something.
> 
> This was the point of the original menu, I think - it allowed each
> partition type to have a default based on arch, but to hide away the
> mess of other types unless you feel like overriding it.
> 
> You'll want to make sure in your patch that arches other than x86 don't
> lose their own native partitioning types :)


Thanks.  I won't bother pushing the latest patch.  :)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
