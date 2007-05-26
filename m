Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXEZGnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXEZGnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 02:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXEZGnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 02:43:17 -0400
Received: from colo.lackof.org ([198.49.126.79]:55053 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXEZGnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 02:43:17 -0400
Date: Sat, 26 May 2007 00:43:07 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Greg KH <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-ID: <20070526064307.GA19177@colo.lackof.org>
References: <m1odkmmft4.fsf@ebiederm.dsl.xmission.com> <20070515212200.517fcba2@osprey.hogchain.net> <m14pmcmz8r.fsf@ebiederm.dsl.xmission.com> <20070516185225.3f3ac082@osprey.hogchain.net> <m1sl9wl28m.fsf@ebiederm.dsl.xmission.com> <20070522204103.134bf5a2@osprey.hogchain.net> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070525052032.GB9386@suse.de> <m1myztaq5s.fsf@ebiederm.dsl.xmission.com> <20070525203501.GD5413@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525203501.GD5413@suse.de>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 01:35:01PM -0700, Greg KH wrote:
...
> And again, over time, like years, this list is going to grow way beyond
> a managable thing, especially as any new chipset that comes out in 2009
> is going to have working MSI, right?  I think our blacklist is easier to
> manage over time, while causing a problem for some users in trying to
> determine their broken hardware that they currently have.
> 
> It's a trade off, and I'd like to choose the one that over the long
> term, causes the least ammount of work and maintaiblity.  I think the
> current blacklist meets that goal.

Before you change your mind again, I agree with the above.
I'm convinced MSI support will only get better and not worse.

The reason is all high speed interconnects (IB, 10gige) and many
storage controllers already support MSI becuase it's more efficient
and will benchmark better at the very least. Server vendors won't be
able to sell their boxes if MSI isn't working.

Desktop has never been as sensitive to IO performance and I don't
know what the situation currently is with laptop gige NICs and
gfx cards (gfx cards use MSI? I don't see it in drivers/video).

thanks,
grant

> thanks,
> 
> greg k-h
