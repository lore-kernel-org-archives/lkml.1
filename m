Return-Path: <linux-kernel-owner+w=401wt.eu-S1763603AbYBLQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763603AbYBLQcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYBLQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:31:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36324 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764083AbYBLQbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:31:51 -0500
Message-ID: <47B1C9F4.30402@garzik.org>
Date: Tue, 12 Feb 2008 11:31:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, John Linville <linville@tuxdriver.com>
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080212044314.GA4888@kroah.com>	<20080211211751.3e265754@laptopd505.fenrus.org>	<20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net>
In-Reply-To: <20080211.220726.157328337.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I rebase my tree all the time, at least once or twice per
> week.  Why?
> 
> Firstly, to remove crap.  When you have "great idea A" then "oh shit A
> won't work, revert that" there is zero sense in keeping both
> changesets around.
> 
> Secondly, I want to fix up the rejects caused by conflicts with
> upstream bug fixes and the like (and there are tons when the tree gets
> to 1500 or so patches like the networking did).  I don't want git to
> merge the thing by hand, I want to see what the conflict is and make
> sure the "obvious" resolution is OK and the most efficient way I know
> how to do that is to suck my tree apart as patches, then suck them
> back into a fresh tree.

FWIW, that is annoying and painful for us downstream jobbers, since it 
isn't really how git was meant to be used.  You use it more like a patch 
queue, where commits are very fluid.

Unfortunately, if there is any synchronization lag between me and you -- 
not uncommon -- then I cannot commit changes on top of the changes just 
sent, in my own local tree.  Why?  Because you rebase so often, I cannot 
even locally commit dependent patches due to the end result merge 
getting so nasty.

I understand the desire to want a nice and clean history, but the 
frequency here really has a negative impact on your downstreams.

It also totally screws the commit statistics, wiping me and John and the 
committers we have preserved out, replacing everybody's committer with 
David Miller.

	Jeff


