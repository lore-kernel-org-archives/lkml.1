Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0CKL5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:57:41 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:42685 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab0CKL5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:57:39 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com>
	<87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com>
	<87zl2j9muz.fsf@devron.myhome.or.jp>
	<87wrxkw52s.fsf_-_@devron.myhome.or.jp>
	<87sk88w4xk.fsf_-_@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com>
Date: Thu, 11 Mar 2010 20:57:35 +0900
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com>
	(Daniel Taylor's message of "Wed, 10 Mar 2010 15:16:59 -0800")
Message-ID: <873a07oyts.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Taylor" <Daniel.Taylor@wdc.com> writes:

> In the near future, WD will be releasing products that need this patch.
>
> Wouldn't it be a better Linux user experience to never have the problem,
> rather than wait for a bug-fix cycle on the kernel?

Of course, if we can fix, it's better.

However, probably, users of this patch would be only boot loader,
because this is a first sector on extended-partition itself, not
logical-partitions in extended-partition.

So, maybe this wouldn't be so major problem for normal users, and what
is needed actually is not sure to me for now (I guess it might be
depending to BIOS, if boot loader is using BIOS call.).

So, this patch provides one logical sector, but it's just guess.

> OTOH, it would be reasonable to wait until someone else had a chance to
> test the change.  We are awaiting NDAs from RedHat, Canonical, and
> Novell/SUSE to send them the affected products for library/application
> development.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
