Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZGAOCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZGAOCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZGAOCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:02:14 -0400
Received: from mail.samba.org ([66.70.73.150]:40889 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbZGAOCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:02:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.27736.647500.497114@samba.org>
Date: Thu, 2 Jul 2009 00:02:00 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090701143844.07728fdf@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > What about all the other damage vendors do to the tree and the junk they
 > stuff in their kernels - we don't accept that upstream either ?

sure, but there is no need to encourage bad behaviour by building it
into the upstream :-)

 > Its manual unless the device is visibly corrupted but it should still
 > work.

ok, with the patch I've posted applied, can you reproduce this?
Perhaps by deliberately corrupting the device in some other way (using
dd?) then running a chkdsk?

If you try to reproduce it then make sure you completely fill the VFAT
directory. If you have (for example) only 1000 files in a directory
then you'd have to redo the deliberate corruption test with new files
about 2000 times before you get a single error and rename from
chkdsk. If you only have 100 files then you'll have to do it nearly a
million times per rename.

 > The point I was making is that the world of "Windows PC & Linux
 > handheld device" is an important one.

yes, it's an extremely important use for Linux. That is why I've spent
the last 4 months working on ensuring that it continues to be viable,
by trying to create the most legally robust, most compatible patch I
can that allows these devices to continue to exist without running
significant legal risks.

If there is another approach that achieves this goal in a better way
then we should look at it. Can you suggest an alternative that will
work better for Linux handheld device makers?

Cheers, Tridge
