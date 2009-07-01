Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZGALa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZGALa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZGALaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:30:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57755 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbZGALaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:30:17 -0400
Date: Wed, 1 Jul 2009 12:31:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701123141.402c17d2@lxorguk.ukuu.org.uk>
In-Reply-To: <19019.16217.291678.588673@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would usually agree, but I think we have an unusual situation here,
> in some ways similar to a demonstrated security hole. The previous
> behaviour exposed a lot of Linux vendors to the possibility of an
> expensive legal fight.

They don't have to ship the code. They can rip it out. They deal with
video players the same way for the USSA market and have done for years.

>   - chkdsk.exe will complain about duplicates, and will rename one of
>     the two files. That is a 50% chance of 1 file being renamed for a
>     single directory containing 60k files. Given it isn't all that
>     common to run chkdsk on removable media that is shared between

Its a standard usage pattern for some people. Think about Linux based
commodity devices such as the N770 and plugging it into the users general
purpose PC box. Whenever it got pulled out wrongly it *will* get a chkdsk
in Windows.

>     Linux and Windows, I thought that this is not a terribly large
>     concern.

Disagree. Its a rapidly growing market segment.
