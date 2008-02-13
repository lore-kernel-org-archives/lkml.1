Return-Path: <linux-kernel-owner+w=401wt.eu-S1764813AbYBMAtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764813AbYBMAtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYBMAto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:49:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53041
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbYBMAtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:49:43 -0500
Date: Tue, 12 Feb 2008 16:50:14 -0800 (PST)
Message-Id: <20080212.165014.01238510.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: bfields@fieldses.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org>
References: <47B1C9F4.30402@garzik.org>
	<20080212193754.GC18625@fieldses.org>
	<alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2008 12:07:07 -0800 (PST)

> 
> 
> On Tue, 12 Feb 2008, J. Bruce Fields wrote:
> > 
> > But the "author" is still preserved, right?  Why do you need the
> > committer name to be preserved?  (I'm not denying that there could be
> > reasons, I'm just curious what they are.)
> 
> It's not that the committer should be preserved, but:
> 
>  - the chain from author -> committer should be visible in the 
>    Signed-off-by: lines.
> 
>    If you rebase somebody elses tree, you screw that up. You need to add 
>    your sign-off, since now *you* are the new committer, and *you* took
>    somebody elses work!

I agree with this and that is exactly what I screwed up by mistake
this time around.

Normally when I rebase I walk through the patches that came from other
people's trees and add signoffs as needed.  I understand that this
is frowned upon to some extent as well.

> Put another way: think of the absolute *chaos* that would happen if I were 
> to rebase instead of just merging. Every time I pull from you I'd 
> invalidate your whole tree, and you'd have to re-generate. It gets 
> unmaintainable very quickly.

I actually wouldn't mind that, the first thing I do when sending a
pull request is I stop putting things into my tree and as soon as the
recipient pulls I wipe out my tree and clone a fresh copy of their's.

It's really not a big deal.  The pusher can queue patches and other
stuff up in their mailbox or in a directory somewhere.  This quiet
period also allows those patches to have some time to be reviewed on
the lists before they actually end up in anyone's tree.

I really like that mode of operation.

