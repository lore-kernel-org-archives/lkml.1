Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYAZOHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYAZOHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYAZOGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:06:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34354
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755533AbYAZOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:06:52 -0500
Date: Sat, 26 Jan 2008 06:07:05 -0800 (PST)
Message-Id: <20080126.060705.53192768.davem@davemloft.net>
To: mingo@elte.hu
Cc: stefanr@s5r6.in-berlin.de, cate@cateee.net, rjw@sisk.pl,
       Valdis.Kletnieks@vt.edu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: using LKML for subsystem development
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080126112820.GA10563@elte.hu>
References: <479A75D4.6070607@s5r6.in-berlin.de>
	<479A8203.40804@s5r6.in-berlin.de>
	<20080126112820.GA10563@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 26 Jan 2008 12:28:20 +0100

> Filter on all mails from David S. Miller if you are interested in 
> networking topics. You'll have a really good grasp of what's going on in 
> that area, without having to invest too much time.

That's a very poor filter, I don't write much code lately in the
networking.

I only provide theoretical direction in a few specific areas I care
about.

As Ingo already knows, I think this "put everything on lkml" argument
is bogus.

And about bisectability, every time I apply a networking patch I do at
the very least a "allmodconfig" build with just that new patch added,
for every patch.  Often I do more extensive build testing.

And when I rebase the tree, I rerun this check after each
patch gets re-applied to a new base tree.

In fact I'm working on such issues as I fly over the Australia
for LCA08 :-)

So this isn't an issue that posting to lkml is going to help.
