Return-Path: <linux-kernel-owner+w=401wt.eu-S966210AbXEGSwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966210AbXEGSwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966192AbXEGSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:52:40 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4586 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985AbXEGSwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:52:39 -0400
X-AuthUser: hirofumi@parknet.jp
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Andreas Schwab <schwab@suse.de>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Long file names in VFAT broken with iocharset=utf8
References: <200705072151.20104.arvidjaar@mail.ru>
	<60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de>
	<jebqgwpkgk.fsf@sykes.suse.de> <200705072243.53150.arvidjaar@mail.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 08 May 2007 03:52:32 +0900
In-Reply-To: <200705072243.53150.arvidjaar@mail.ru> (Andrey Borzenkov's message of "Mon\, 7 May 2007 22\:43\:52 +0400")
Message-ID: <87bqgw5uvj.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> writes:

> On Monday 07 May 2007, Andreas Schwab wrote:
>> Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:
>> > PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does not
>> > matter. ISTR that PATH_MAX was 256 at some point, but I just  quickly
>> > grepped /usr/include and found various mention of 4096, so  where's the
>> > central repository for this configuration item? A hard-
>> > coded value of 256 somewhere inside the kernel smells like a bug.
>>
>> There is PATH_MAX and there is NAME_MAX, and only the latter (which is
>> 260 for vfat) matters here.
>>
>
> Do you imply that Linux is unable to represent full VFAT names (255 UCS2 
> charaters) by design? Hmm ... testing ... looks like it,

Yes. But I think it's not design, and it should be fixed.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
