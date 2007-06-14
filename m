Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbXFNOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbXFNOVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXFNOVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:21:14 -0400
Received: from holomorphy.com ([66.93.40.71]:35877 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbXFNOVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:21:12 -0400
Date: Thu, 14 Jun 2007 07:21:46 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Alex Riesen <raa.lkml@gmail.com>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc4: known regressions v3
Message-ID: <20070614142146.GN15426@holomorphy.com>
References: <46704923.1010009@googlemail.com> <46704C44.8020602@googlemail.com> <Pine.LNX.4.61.0706132320200.26751@mtfhpc.demon.co.uk> <20070614020055.GL15426@holomorphy.com> <Pine.LNX.4.61.0706141123160.28903@mtfhpc.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0706141123160.28903@mtfhpc.demon.co.uk>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 11:30:25AM +0100, Mark Fortescue wrote:
> They apear as soon as simpleinit starts up. Somtimes I get to a login 
> prompt before seeing any. Other times, commands in the simpleinit rc 
> script fail.
> They do apear to be random. If a command failes, you re-run the command 
> and it is OK. Commands seen to fail are basic (depmod, rm cat ..).
> The test I did use the same binaries with both the OK and problem kernels 
> so it is not a change to the application code, it is definatly a kernel 
> issue.

This sounds like it may be addressed by benh's ptep_set_access_flags()
fixes. Those fixes are still in -mm, hopefully to hit mainline by 2.6.22.


-- wli
