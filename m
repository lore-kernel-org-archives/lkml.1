Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0CCOCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:02:10 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45916 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab0CCOCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:02:09 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Daniel Taylor" <Daniel.Taylor@wdc.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
Date: Wed, 03 Mar 2010 23:02:03 +0900
In-Reply-To: <20100301141335.395dc4c3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 1 Mar 2010 14:13:35 -0800")
Message-ID: <873a0h1p2c.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 24 Feb 2010 19:17:47 -0800
> "Daniel Taylor" <Daniel.Taylor@wdc.com> wrote:
>
>> In order to use disks larger than 2TiB on Windows XP, it is necessary to use
>> 4096-byte logical sectors in an MBR.

BTW, you can use GPT instead?

And to make sure, "4096-byte logical sectors in an MBR" is meaning, the
storage must be supporting 4096B and is using it?

>> Although the kernel storage and functions called from msdos.c used
>> "sector_t" internally, msdos.c still used u32 variables, which results in
>> the ability to handle XP-compatible large disks.
>> 
>> This patch changes the internal variables to "sector_t".
>> 
>
> Please Cc OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> and myself on
> this work.

BTW, to make sure, this is fs/partitions/, not fs/fat/. So, I'm not
sure, my knowledge is enough or not, and/or you just missed
fs/partitions/.

Well, I'll make time to check. BTW, basically it sounds good to me
except implementation details. But, I'd like to compare and check other
implement a bit if possible. IIRC, this is not a well defined
specification.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
