Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbZGBEEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbZGBEEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 00:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZGBEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 00:04:46 -0400
Received: from mail.samba.org ([66.70.73.150]:34128 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZGBEEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 00:04:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19020.12748.348370.708306@samba.org>
Date: Thu, 2 Jul 2009 14:04:28 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090701154151.7f45abad@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	<19019.27736.647500.497114@samba.org>
	<20090701154151.7f45abad@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > They can type 
 > 
 > patch -p1 < linux-foundation-recommended-ussa-fat.patch
 > 
 > which removes all the subversive terrorist code that Americans are scared
 > to posess.

I think you'll find that most distro makers and most vendors of Linux
based devices will want to have this patch applied. So if we took the
approach you suggest, then the testing done via kernel.org trees will
not match what the vast majority of Linux users will actually be
running. That would seem to be counter to good QA practices.

If the patch had significant negative consequences for normal use then
I'd be proposing the default be for dualnames to be enabled, which is
why the first patch I posted in May that disabled creation of long
filenames defaulted to off.

So please do as much testing as you have time for, and I'll continue
to ask people to let me try their mobile phones with a microSD card
and see how many different embedded OSes I can test that way. So far
the count is zero devices affected in a negative way by the proposed
patch.

If we get some real examples of devices that are badly affected then
we could revisit the question of what the default should be. With the
count at zero it seems counter-productive to disable this change in
the git trees that will allow it to get some wider testing.

Cheers, Tridge
