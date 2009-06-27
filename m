Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZF0Bsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZF0Bsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 21:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZF0Bsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 21:48:30 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40890 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZF0Bs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 21:48:29 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org> <4A45405A.1010404@zytor.com>
	<19013.18894.749105.721881@samba.org>
Date: Sat, 27 Jun 2009 10:48:25 +0900
In-Reply-To: <19013.18894.749105.721881@samba.org> (tridge@samba.org's message
	of "Sat, 27 Jun 2009 08:21:02 +1000")
Message-ID: <87k52yzbti.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> hpa wrote:
>  > However, as such it really should be paired with a "don't even recognize
>  > the shortname if a longname exists" option.
>
> Right, we could just skip the 8.3 name matching and go straight to the
> longname match in fat_search_long(). I wonder if anyone ever relies on
> the 8.3 matching when a file has a long name on Linux?

Wine or such is using it.

>  > It's also questionable IMO if this shouldn't be another FAT superdriver,
>  > just as we have VFAT, MS-DOS etc. we could have "purevfat".
>
> It would be only a few lines of code difference between the two
> drivers - is it worth the maintainence overhead of splitting it up?
>
> Maybe a mount option to ignore 8.3 names for files with long names
> would be better? Perhaps even the default?

It sounds like to be start of yet another UMSDOS with minimal one. I
wouldn't like to repeat UMSDOS history, i.e. I think it needs real users
and developers. If not, I wouldn't like to add.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
