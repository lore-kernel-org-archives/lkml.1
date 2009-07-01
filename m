Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZGALdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZGALdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZGALd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:33:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44910 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbZGALd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:33:28 -0400
Date: Wed, 1 Jul 2009 12:34:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701123453.1ca00b4f@lxorguk.ukuu.org.uk>
In-Reply-To: <19019.17531.349844.201397@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<20090701110934.2f43591c@lxorguk.ukuu.org.uk>
	<19019.17531.349844.201397@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Agreed 100%. I'm also not sure it should be called "vfat" when operating
>  > in this mode as it's not vfat any more - it needs a new name.
> 
> If the code differed significantly between the two implementations I'd
> probably agree, but as the two are extremely close I think maintaining
> a separate filesystem isn't worth it.

It needs a different name to the user. If the new fs isn't vfat (which it
isn't) and doubly so if it can crash Windows XP at random on very rare
occasions then users need to know its different.

Imagine someone sticks a Linux written disk into a mission critical
windows server - I think they have a right to know and not accidentally
wander into a situation where they bring that box down ?

mount -o vfat should fail for this non-vfat.

