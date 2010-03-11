Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab0CKWke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:40:34 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33369 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0CKWkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:40:33 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
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
	<873a07oyts.fsf@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
	<87vdd2fqpr.fsf@devron.myhome.or.jp> <4B996E58.6010407@zytor.com>
Date: Fri, 12 Mar 2010 07:40:30 +0900
In-Reply-To: <4B996E58.6010407@zytor.com> (H. Peter Anvin's message of "Thu,
	11 Mar 2010 14:27:36 -0800")
Message-ID: <87r5nqfpnl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/11/2010 02:17 PM, OGAWA Hirofumi wrote:
>>
>> Those are all about the first (1/2) patch, not this second patch.
>> Personally, I'm thinking we should apply the first patch as bugfix.
>>
>> I'm talking about only second (2/2) patch in here.
>>
>
> The 2/2 patch seems to be a bug fix too; it implements the intent of the 
> original code as far as I can see.

Yes, however the state is not so sure if compared to first patch. So I
said, if we want, we can drop it (2/2), because it's not so sure to fix
the real problem (bootloader's requirement).

Even if we apply this patch too, it shouldn't introduce new problems
though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
