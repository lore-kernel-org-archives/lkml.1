Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXLIBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXLIBJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 20:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXLIBJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 20:09:12 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:42411 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbXLIBJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 20:09:10 -0500
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom
	deplete entropy so much?)
From: Jon Masters <jonathan@jonmasters.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Willy Tarreau <w@1wt.eu>, Jeff Garzik <jeff@garzik.org>,
       Matt Mackall <mpm@selenic.com>, Mike McGrath <mmcgrath@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
In-Reply-To: <20071208234721.GR17037@thunk.org>
References: <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com>
	 <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion>
	 <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com>
	 <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org>
	 <475AF241.5000809@garzik.org> <20071208204239.GG15227@1wt.eu>
	 <20071208234721.GR17037@thunk.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 08 Dec 2007 20:07:51 -0500
Message-Id: <1197162471.12636.6.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 18:47 -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 09:42:39PM +0100, Willy Tarreau wrote:
> > I remember having installed openssh on an AIX machines years ago, and
> > being amazed by the number of sources it collected entropy from. Simple
> > commands such as "ifconfig -a", "netstat -i" and "du -a", "ps -ef", "w"
> > provided a lot of entropy.
> 
> Well.... not as many bits of entropy as you might think.  But every
> little bit helps, especially if some of it is not available to
> adversary.

I was always especially fond of the "du" entropy source with Solaris
installations of OpenSSH (the PRNG used commands like "du" too). It was
always amusing that a single network outage at the University would
prevent anyone from ssh'ing into the "UNIX" machines. So yeah, if we
want to take a giant leap backwards, I suggest jumping at this.

Lots of these are not actually random - you can guess the free space on
a network drive in some certain cases, you know what processes are
likely to be created on a LiveCD, and many dmesg outputs are very
similar, especially when there aren't precie timestamps included.

But I do think it's time some of this got addressed :-)

Cheers,

Jon.


