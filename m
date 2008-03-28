Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYC1EnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYC1EnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYC1EnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:43:06 -0400
Received: from gherkin.frus.com ([192.158.254.49]:37150 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYC1EnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:43:05 -0400
Subject: Re: 2.6.25-rc7: Ugh.
In-Reply-To: <20080327.201202.163153963.davem@davemloft.net> "from David Miller
 at Mar 27, 2008 08:12:02 pm"
To: David Miller <davem@davemloft.net>
Date: Thu, 27 Mar 2008 23:42:58 -0500 (CDT)
CC: lkml@rtr.ca, jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080328044258.7AA98DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mark Lord <lkml@rtr.ca>
> Date: Thu, 27 Mar 2008 21:57:55 -0400
> 
> > I don't have the XX days necessary for git-bisect right now.
> 
> I wish people would say stuff like this.
> 
> It takes 20 to 40 minutes, tops, to do this.
> 
> The bulk of it can run in the background while you perform other
> tasks.

I don't understand this claim.  On what incredibly fast piece of iron
can you possibly do between 8 and 16 kernel builds (the range I've
encountered when I do the "git bisect" dance), boot each one, and
evaluate the results in so small a period of time?  An Alpha kernel
build takes me between 5 and 10 minutes for minor changes, closer to
four *hours* for a "from scratch" (make clean) build.  Even worse: for
those of us who don't have access to the console of the test machine
continuously (e.g., the machine is at home and you normally work outside
the home), the whole bisection process can take several days to complete.

Yes, Mark's problem is with a laptop, and maybe he's allowed to take
it with him into his workplace, but still...

If your claim is 20 to 40 minutes "per iteration", I could believe that.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
