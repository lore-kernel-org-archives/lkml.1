Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXFNPBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXFNPBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXFNPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:01:39 -0400
Received: from holomorphy.com ([66.93.40.71]:57257 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbXFNPBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:01:37 -0400
Date: Thu, 14 Jun 2007 08:02:19 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alex Riesen <raa.lkml@gmail.com>,
       Andi Kleen <ak@suse.de>, Ioan Ionita <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc4: known regressions v3
Message-ID: <20070614150219.GG6909@holomorphy.com>
References: <46704923.1010009@googlemail.com> <46704C44.8020602@googlemail.com> <Pine.LNX.4.61.0706132320200.26751@mtfhpc.demon.co.uk> <20070614020055.GL15426@holomorphy.com> <Pine.LNX.4.61.0706141123160.28903@mtfhpc.demon.co.uk> <20070614142146.GN15426@holomorphy.com> <Pine.LNX.4.61.0706141539140.29274@mtfhpc.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0706141539140.29274@mtfhpc.demon.co.uk>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 03:57:25PM +0100, Mark Fortescue wrote:
> Benh's ptep_set_access_flags() patch needs to be applied in order to get 
> anyware with sun4c for all kernels >= linux-2.6.15. If not applied, you 
> will be lucky to get sash running as your init and even that will have 
> very limitit capabilities before it locks up the processor (power up 
> reset required).
> It has been applied to both the kernels I used for testing so this 
> problem is independent of the ptep_set_access_flags patch but that 
> does not mean that it is not a related issue.
> I will try to get some testing done over the weekend to narrow down 
> when the random illegal instructions first occour.
> If I start with 2.6.21 then if that is OK, then I should be able to narow 
> the issue down without too much trouble. If it is between 2.6.20 and 
> 2.6.21 then it will be a right pig as there are a large number of commits 
> that don't compile for sun4c between these two. What I am hoping is that 
> it occours in the 2.6.22-rc2 as per the x86_64.

Sounds like I'll be digging through my hardware stockpiles this weekend
to find a functional sun4c box.


-- wli
