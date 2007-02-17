Return-Path: <linux-kernel-owner+w=401wt.eu-S965299AbXBQQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299AbXBQQJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965301AbXBQQJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:09:21 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:58140 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965299AbXBQQJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:09:20 -0500
Date: Sat, 17 Feb 2007 11:09:19 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070217160919.GT7584@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca> <20070126142041.GD7584@csclub.uwaterloo.ca> <45BA1556.8080808@microgate.com> <20070126145608.GK7582@csclub.uwaterloo.ca> <45BA190C.5040300@microgate.com> <20070126160842.GM7582@csclub.uwaterloo.ca> <20070129192707.GE7584@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129192707.GE7584@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 02:27:07PM -0500, Lennart Sorensen wrote:
> I have run some tests with 8 patches from Linus's 2.6 tree on top of the
> 2.6.16.25 along with a bit of debug code in the n_tty.c, which ran
> perfectly for 3 days.  I now removed the debug code to see if it will
> still run perfectly with those 8 patches.  The patches I applied in
> order are:
> 
> commit 70522e121a521aa09bd0f4e62e1aa68708b798e1
> commit 41c28ff1635e71af072c4711ff5fadd5855d48e7
> commit 1aef821a6b3aeca8c19d06aee012ed9db617d1e3
> commit ee37df7877eeaa16d7761cce64854110a7c17ad9
> commit e1a2509023785bd3199ac068ab80155aeba01265
> commit 817d6d3bceaf34c99f5343820f9b9e6021f0655c
> commit 2c3bb20f46709a0adfa7ea408013edbcab945d5a
> commit 33b37a33c242542fac2980b8ccd90977388b7a8d
> 
> Hopefully it will stay working, and actually be a solution to my tty
> problem in 2.6.16.25.
> 
> 2.6.18.2 (Debian 2.6.18-4) on the other hand was still broken, but I am
> not sure which if any of the above commits are not in that version (the
> date ranges made me think they all should be, but maybe I got the date
> of 2.6.18 wrong, or not all commits in the linux-2.6 tree are actually
> part of a given release.  I am still figuring out git).

2.6.18 does work, it failed in different ways (overruns on the fifo)
which I dealt with by ensuring disk io was synced before testing the
serial port.

--
Len Sorensen
