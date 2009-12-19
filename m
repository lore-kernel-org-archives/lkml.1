Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbZLSLv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbZLSLv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 06:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZLSLv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 06:51:56 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:44200 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZLSLvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 06:51:55 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: revert "config FS_JOURNAL_INFO"
References: <b6fcc0a0912170031u162b7f56kf9f6adc23e24278c@mail.gmail.com>
	<4B2AFF4C.5010100@ct.jp.nec.com>
	<b6fcc0a0912172325i34d214d3r11b3bfae7381547f@mail.gmail.com>
Date: Sat, 19 Dec 2009 20:51:49 +0900
In-Reply-To: <b6fcc0a0912172325i34d214d3r11b3bfae7381547f@mail.gmail.com>
	(Alexey Dobriyan's message of "Fri, 18 Dec 2009 09:25:51 +0200")
Message-ID: <877hsjw59m.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On 12/18/09, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
>> So we never allow to make memory usage small with providing an option
>> to remove unused area, right?
>
> We certainly allow this if it results in zero loss in functionality.
>
>> If I want to reduce memory usage by this way, should I keep
>> this kind of patches out of tree?
>
> Certainly nobody can prohibit you from keeping patch out of tree.
> But if you want something mainlinable, moving ->journal_info
> to fs-specific data structures should do the trick. Or something.

Why doesn't this use EMBEDDED?

I.e.

	boot "xxx" if EMBEDDED
	default y

style Kconfig.

Only reason which seems reasonable is "this is done only for one pointer
on task_struct". This reason seems something like "You care, but I don't
care it". And, other reasons is *normal* situation on EMBEDDED, right?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
