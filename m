Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYBMALm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYBMALm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYBMALc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:11:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbYBMALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:11:31 -0500
Date: Tue, 12 Feb 2008 16:12:03 -0800 (PST)
Message-Id: <20080212.161203.16478915.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212170422.GE3051@tuxdriver.com>
References: <20080211.220726.157328337.davem@davemloft.net>
	<47B1C9F4.30402@garzik.org>
	<20080212170422.GE3051@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 12 Feb 2008 12:04:22 -0500

> 	net-2.6.26		updates certain to go to the next release
> 	net-2.6.26-maybe	updates that might not make it to the next release

If I knew something was "maybe" ahead of time I simply would not apply
it.

Everything I apply to my tree I feel is likely to get integrated.  If
it isn't, I let the patch work itself out on the lists and amongst the
interested developers.

The real issue is deleting crap.  Once something that seemed like a
good idea turns sour I want to remove it entirely.  This isn't doable
without a rebase.

Also, and Andrew does this a lot, I want to clean up changes which
have problems I only notice later.  In fact the rebase process turns
up all kinds of things such as whitespace errors that I get when
merging other people's trees.  Having extra changesets with the
small fixups adds zero value and just more churn to go over when
reading changesets.  A small annotation to the changelog will
do, that answers the "where did this come from?".

With patches and rebasing that operation is easy, and I'm willing to
deal with all of the rebasing of subsequent changesets that is usually
caused by such things.  Yes, I'm even willing to do it to patch #1 in
a 1500 patch tree. :-)
