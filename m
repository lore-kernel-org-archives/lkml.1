Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbYBZPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbYBZPlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbYBZPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:41:13 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:48256 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYBZPlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:41:12 -0500
Date: Tue, 26 Feb 2008 15:41:02 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Bongani Hlope <bonganilinux@mweb.co.za>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Message-ID: <20080226154102.GD30463@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080218131125.2857f7c7@gaivota> <200802182320.40732.bonganilinux@mweb.co.za> <200802190121.36280.bonganilinux@mweb.co.za> <20080219111640.409870a9@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219111640.409870a9@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 1JU1vN-0008W7-0i
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=1.608, required 7,
	autolearn=disabled, HELO_LOCALHOST 4.50, RCVD_IN_NERDS_IE -3.50,
	RCVD_IN_PBL 0.51, RDNS_NONE 0.10)
X-blacknight-igraine-MailScanner-SpamScore: s
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bisecting this won't be that easy. The support for the depreciated V4L1 API
> were removed from bttv driver. Now, it uses v4l1-compat module, that translates
> a V4L1 call into a V4L2 one. I'll try to seek for troubles at the current code.

I think I might have seen this problem but it didn't cause a oops for
me, just that the radio program would hang waiting for the ioctl syscall
to return.  I did tried looking for a new radio program that used the
V4L2 API but couldn't find one.  I'll have a more in-depth look at the
bttv driver when I get home tonight.

Robert

