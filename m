Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZGBKaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZGBKaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZGBKan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:30:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44850 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbZGBKan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:30:43 -0400
Date: Thu, 2 Jul 2009 11:32:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702113200.39a15f21@lxorguk.ukuu.org.uk>
In-Reply-To: <19020.12748.348370.708306@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	<19019.27736.647500.497114@samba.org>
	<20090701154151.7f45abad@lxorguk.ukuu.org.uk>
	<19020.12748.348370.708306@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you'll find that most distro makers and most vendors of Linux
> based devices will want to have this patch applied. So if we took the

Good for them

> approach you suggest, then the testing done via kernel.org trees will
> not match what the vast majority of Linux users will actually be
> running. That would seem to be counter to good QA practices.

The vendor trees all contain patches and have done for years, often lots
of them. They will apply the patch if you put VFAT_DUALNAMES into the
kernel as well so your argument is totally bogus. It always was totally
bogus, it always will be. Vendors do not use the base kernel as is in
normal product. They ship

	Base kernel
	+ Patches for packaging systems
	+ .1/.2/.3 bits
	+ Cherry pick of stuff that deals with bugs they think have to be
	  stomped by some means
	+ drivers they add which are not yet fit for kernel
	+ exciting stuff they think is cool and makes their distro
	  special (eg KMS patches)


Its starting to sound like the Foundation and someone have signed some
kind of settlement to get this change into the Linux kernel regardless of
the technical issues, practicality or community and this is all for show
anyway.

> If the patch had significant negative consequences for normal use then

You said yourself it can crash XP.

> If we get some real examples of devices that are badly affected

XP crashing by suprise if you are really really unlucky strikes me as a
good example and one you provided.

You've also ignored entirely the fact that this isn't a VFAT file system
so irrespective of whether this goes in it should not be used for mount
-o vfat.

There is a clear end user expectation that vfat means "microsoft fat with
extended names". By all means add support for "not vfat" but don't call
it "vfat" as that is misleading an interface breakage.


