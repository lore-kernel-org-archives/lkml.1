Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYBMBhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYBMBhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYBMBhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:37:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48898
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbYBMBhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:37:45 -0500
Date: Tue, 12 Feb 2008 17:38:17 -0800 (PST)
Message-Id: <20080212.173817.111913348.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: bfields@fieldses.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802121156400.2920@woody.linux-foundation.org>
	<20080212.165014.01238510.davem@davemloft.net>
	<alpine.LFD.1.00.0802121710510.2920@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2008 17:31:10 -0800 (PST)

> You don't see the problems as much, because you merge probably only
> about a tenth of the volume I merge, and you can keep track of the
> subsystem more.

Good point.

Now how do I remove a bogus commit for a tree that I've already pushed
out and published for other people, without any record of it appearing
in the GIT tree any more?

How do I insert build fixes into existing changesets so that the tree
is more bisectable?

If Jeff merged in a tree that introduced a ton of whitespace errors
git is complaing about, is there a way I can fixup that changeset
in-place? (or should I tell Jeff to start adhering to GIT's whitespace
warning messages when he applies patches?)

Those are basically the major operations that would allow me to
seriously consider rebasing a ton less often.
