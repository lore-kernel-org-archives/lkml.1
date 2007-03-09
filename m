Return-Path: <linux-kernel-owner+w=401wt.eu-S2992986AbXCIFwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992986AbXCIFwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992987AbXCIFwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:52:12 -0500
Received: from waste.org ([66.93.16.53]:45030 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992986AbXCIFwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:52:10 -0500
Date: Thu, 8 Mar 2007 23:39:32 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309053931.GA10459@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First off, let me say that I think your approach has great promise,
but I'm afraid it doesn't work so well here yet.

Box is an R51 Thinkpad, 1.7GHz Pentium M. I'm using a make -j 5 as a
test load.

With 2.6.21-rc2-mm2, I get slightly sluggish response for opening new
terminals, scrolling in Galeon, and a bit jerky behaviour for spinning
Beryl's 3D desktop. Playing MP3s off an sshfs FUSE mount works fine.
Typing across ssh sessions has no noticeable lag. Mouse pointer
movement is smooth.

With 2.6.21-rc3-mm1, terminals take longer to open, Galeon is
noticeably more sluggish, and Beryl's desktop switching goes from being
jerky to a 5-second agony. Typing in shells, remote or not,
lags noticeably. Mouse pointer is alternately smooth or jerky. But
MP3s still work great!

Problems persist with make -j 2 and make.

-- 
Mathematics is the supreme nostalgia of our time.
