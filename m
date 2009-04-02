Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbZDBRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbZDBRWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbZDBRWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:22:08 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:59416
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756648AbZDBRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:22:06 -0400
Date: Thu, 2 Apr 2009 19:21:56 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 30: [BUG] kmemleak page fault
Message-ID: <20090402172156.GD14253@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090330200145.8d0da09b.sfr@canb.auug.org.au> <20090330122437.GA4784@traven> <1238578208.14550.4.camel@pc1117.cambridge.arm.com> <20090401095207.GH8877@traven> <1238688515.28457.120.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238688515.28457.120.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, Apr 02, 2009 at 05:08:35PM +0100 Catalin Marinas ha dit:

> On Wed, 2009-04-01 at 11:52 +0200, Matthias Kaehlcke wrote:
> > El Wed, Apr 01, 2009 at 10:30:08AM +0100 Catalin Marinas ha dit:
> > 
> > > On Mon, 2009-03-30 at 14:24 +0200, Matthias Kaehlcke wrote:
> > > > linux-next 20090330 causes the following page fault on an edb9302
> > > > (ARM) like board:
> > > [...]
> > > > the fault is reproducible and happens some seconds after having
> > > > finished the boot process. please tell me if you need more information
> > > > (like the .config, ...) in order to track this down
> > > 
> > > Yes, the .config would be useful. I'm mainly interested in which slab
> > > allocator you are using. I'm testing kmemleak mainly on ARM and haven't
> > > seen any issues.
> > 
> > attached is the .config for linux-next 20090401, which should be
> > roughly the same than the 20090330 one.
> > 
> > some hours ago i booted the board with 20090401 and the page fault
> > didn't happen
> 
> Do you still get this fault with the latest linux-next? I can't
> reproduce it on my ARM platform (I tried it with the latest mainline
> kernel as well).

still haven't tried with 20090402, but with 20090401 i didn't get the
fault
 
-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

  Control over the use of one's ideas really constitutes control over other
  people's lives; and it is usually used to make their lives more difficult.
                          (Richard Stallman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
