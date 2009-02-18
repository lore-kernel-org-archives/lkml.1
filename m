Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZBROBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZBROBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZBROBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:01:38 -0500
Received: from THUNK.ORG ([69.25.196.29]:57530 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZBROBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:01:37 -0500
Date: Wed, 18 Feb 2009 08:55:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, arvidjaar@mail.ru, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression? Bonding tied to IPV6 in 29-rc5
Message-ID: <20090218135537.GF3600@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
	arvidjaar@mail.ru, rjw@sisk.pl, netdev@vger.kernel.org,
	bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
	linux-kernel@vger.kernel.org
References: <200902172001.41804.arvidjaar@mail.ru> <20090217.142946.232071526.davem@davemloft.net> <25143.1234932076@turing-police.cc.vt.edu> <20090217.212919.259912220.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217.212919.259912220.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 09:29:19PM -0800, David Miller wrote:
> Next, if it's just an issue of IPV6 traffic, install a packet
> scheduler rule that rejects all packets with ethernet proto
> ETH_P_IPV6
> 
> If openning up ipv6 sockets is problematic, that can be blocked
> using the security layer, which your super-duper distro kernel
> is guarenteed to have enabled. :-)
> 
> I'm sure there is someone who has legacy problems with ipv4
> and that can't be disabled, and somehow people cope.  Amazing.

The reality is that there are far more people who have legacy problems
with ipv6 than ipv4 (which has been around and in active use for about
3 decades, after all), whereas ipv6 has been around and largely
ignored for about a decade.  :-/

I'll admit that I ran into some wierd sh*t problems with some open
source software or another failing mysteriously when IPv6 was enabled,
and I dealt with it by simply disabling IPv6 (yeah, I blocked the
module).  I was in a hurry, and it just didn't work, and I had better
thing to do than to spend time trying to debug why the presense of an
IPv6 enabled interface caused programs to misbehave in random ways.

I think I can pretty much guarantee that distro users will be
clamoring for a quick and easy way to block ipv6, and it's in our
interest to document the recomended way to block it that doesn't cause
weird problems with bonding, etc.

						- Ted
