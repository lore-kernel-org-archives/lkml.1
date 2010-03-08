Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0CHJgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:36:11 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:43427 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0CHJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:36:09 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com>
	<87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com>
Date: Mon, 08 Mar 2010 18:36:04 +0900
In-Reply-To: <4B9440FC.3090502@zytor.com> (H. Peter Anvin's message of "Sun,
	07 Mar 2010 16:12:44 -0800")
Message-ID: <87zl2j9muz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/07/2010 04:09 PM, OGAWA Hirofumi wrote:
>>
>> It means,
>>
>> 	min(size, max(logical_sector_size / 512, 2));
>>
>> or like this? ("size" is "nr_sects(part) * (logical_sector_size/512)")
>>
>> This should keep old logic, i.e. if partition is bigger than 1kb, it
>> uses 1kb for (probably) LILO mentioned by comment.
>>
>
> I don't really know where the 1K cames from, and it isn't necessarily 
> safe, either.

Um..., I see. However, it wouldn't also be the reason to remove this 1kb
logic. So, I'll just use the above code with some comments for now,
it'll be by separated incremental patch though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
