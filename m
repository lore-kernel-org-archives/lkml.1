Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbZF2Xg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbZF2Xg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZF2XgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:36:19 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44068 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZF2XgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:36:18 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
	<19016.6463.997760.757811@samba.org>
	<20090629221826.GA12781@kroah.com>
	<19017.17250.371594.268824@samba.org>
Date: Tue, 30 Jun 2009 08:36:13 +0900
In-Reply-To: <19017.17250.371594.268824@samba.org> (tridge@samba.org's message
	of "Tue, 30 Jun 2009 08:42:42 +1000")
Message-ID: <87tz1ymx3m.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

>  > I have no objection to take this patch for the -stable releases when it
>  > goes into Linus's tree.  Just forward the git commit ids to
>  > stable@kernel.org and I can take care of it.
>
> ok, thanks Greg.
>
> Hirofumi-san tells me we've missed the merge window for 2.6.31, so it
> seems that this will go first into the fatfs tree, then go into
> Linus's tree via -next for 2.6.32. So hopefully the patch will get
> some more testing (perhaps in -mm?) before it needs to be considered
> for -stable.

Yes. And I will not drop this patch even if it's not perfect on test. I
can understand it would not be the option for some users. The default
may be arguable though, like I said at first.

My choice is to provide the option of those to users.

> Meanwhile some of the distros and other vendors might decide to apply
> it sooner depending on their level of legal concern.

Yes, it's good.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
