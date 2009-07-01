Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZGANhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZGANhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGANh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:37:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36978 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbZGANhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:37:25 -0400
Date: Wed, 1 Jul 2009 14:38:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701143844.07728fdf@lxorguk.ukuu.org.uk>
In-Reply-To: <19019.25035.244941.352337@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yes, vendors can make the patch unconditional of course. I thought
> that we were not trying to encourage divergance between the kernel.org
> tree and the vendor trees though? I know some divergance is always
> going to happen, but it seems counter productive to be encouraging it.

What about all the other damage vendors do to the tree and the junk they
stuff in their kernels - we don't accept that upstream either ?

> 
>  > Its a standard usage pattern for some people. Think about Linux based
>  > commodity devices such as the N770 and plugging it into the users general
>  > purpose PC box. Whenever it got pulled out wrongly it *will* get a chkdsk
>  > in Windows.
> 
> really? I haven't noticed that behaviour for removable devices in
> windows. You can manually set a drive to be checked on reboot, but I
> wasn't aware of any automatic chkdsk mechanism for VFAT removable
> media in windows. Have you seen this yourself?

Its manual unless the device is visibly corrupted but it should still
work. The point I was making is that the world of "Windows PC & Linux
handheld device" is an important one.

> lot of the time. If people manually ran windows chkdsk on removable
> VFAT media created on Linux then they also would have hit this and I
> would have expected at least someone to have mentioned it.

Devices come formatted for VFAT already - and I can't duplicate your bug
report on a USB key here so presumably some specific size/defaults are
needed ? (Would be good to fix that anyway)
