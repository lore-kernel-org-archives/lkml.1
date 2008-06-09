Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYFIE70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYFIE70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYFIE7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:59:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33900 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYFIE7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:59:18 -0400
Message-ID: <484CB475.7070707@zytor.com>
Date: Sun, 08 Jun 2008 21:41:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: "H. Peter Anvin" <hpa@kernel.org>, Adrian Bunk <bunk@kernel.org>,
       =?UTF-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       =?UTF-8?B?T251ciBLw7zDp8O8aw==?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.26 patch] fat_valid_media() isn't for userspace
References: <200806082116.50355.caglar@pardus.org.tr>	<20080608184310.GD4048@cs181133002.pp.htv.fi>	<87prqrn4d8.fsf@duaron.myhome.or.jp> <484C83D9.2020402@kernel.org> <87iqwjmekq.fsf@duaron.myhome.or.jp>
In-Reply-To: <87iqwjmekq.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
>>
>> We need to make this either __kernel_dirent_t[*] or something like 
>> struct __msdos_fs_dirent.
> 
> I see. "struct dirent" in linux/dirent.h has very few users in kernel,
> and probably userland doesn't use it, so it seems it should be renamed.
> 
> Well, the patch is like this (sorry, other cleanup is in this patch)?
> BTW, does typedef help it in this case?
> 

If we're using a FAT-specific structure, then no, there is no reason to 
use a typedef.

	-hpa

