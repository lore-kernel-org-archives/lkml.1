Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZF2WnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZF2WnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZF2Wmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:42:53 -0400
Received: from mail.samba.org ([66.70.73.150]:55531 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZF2Wmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:42:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19017.17250.371594.268824@samba.org>
Date: Tue, 30 Jun 2009 08:42:42 +1000
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Eric W. Biederman" <ebiederm@xmission.com>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090629221826.GA12781@kroah.com>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org>
	<19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
	<19016.6463.997760.757811@samba.org>
	<20090629221826.GA12781@kroah.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I have no objection to take this patch for the -stable releases when it
 > goes into Linus's tree.  Just forward the git commit ids to
 > stable@kernel.org and I can take care of it.

ok, thanks Greg.

Hirofumi-san tells me we've missed the merge window for 2.6.31, so it
seems that this will go first into the fatfs tree, then go into
Linus's tree via -next for 2.6.32. So hopefully the patch will get
some more testing (perhaps in -mm?) before it needs to be considered
for -stable.

Meanwhile some of the distros and other vendors might decide to apply
it sooner depending on their level of legal concern.

Cheers, Tridge
