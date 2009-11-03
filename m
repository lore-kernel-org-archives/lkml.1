Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZKCRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZKCRBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZKCRBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:01:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZKCRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:01:21 -0500
Date: Tue, 3 Nov 2009 08:59:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <1257266647.3420.105.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030851440.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
  <1257262588.3420.79.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>  <1257264485.3420.87.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030815180.31845@localhost.localdomain>
 <1257266647.3420.105.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Marcel Holtmann wrote:
> 
> However to be fair here, this one didn't hit everybody. I for myself
> haven't seen it at all and actually I have been running this "faulty"
> kernel for a while now and suspending happily multiple times a day. As
> much as you hate that the patch for this bug took longer than needed to
> find its way into your tree, the immediate need and the wide problem was
> not clear.

I do not agree.

A _single_ NULL pointer report should have made it clear. As mentioned, I 
was involved in one of the "please revert" threads, and I looked at the 
code, and it was obviously bogus. I could (and did) point to the exact 
memcpy() that caused the problem.

There really was no excuse. That 7d930bc33 commit had a NULL pointer 
dereference, and people hit it. End of story.

The fact that not _all_ people hit it explains how it got pulled into my 
tree in the first place, but that's it.

			Linus
