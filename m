Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYFZSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYFZSP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYFZSPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:15:17 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42521 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYFZSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:15:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Peterson <joe@skyrush.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>
	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>
	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com>
	<87zlp8w4br.fsf@devron.myhome.or.jp> <4863D037.90504@skyrush.com>
Date: Fri, 27 Jun 2008 03:15:10 +0900
In-Reply-To: <4863D037.90504@skyrush.com> (Joe Peterson's message of "Thu, 26
	Jun 2008 11:21:59 -0600")
Message-ID: <87k5gct64x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> writes:

> OGAWA Hirofumi wrote:
>> If so, I'd like to see "tz=xxx" or something for the future, instead of
>> "utc", don't you think so? I really hate to add the random options.
>
> One question: do you see the "tz=" option having "xxx" being a numerical
> offset or a time zone.

Ah, sorry. I was imagining, e.g. POSIX TZ string like
"EST5EDT,M3.2.0/2,M11.1.0 " or something, it is not a simple numerical.

> If the latter, then the DST situation could be
> solved (and tz=UTC could be used to get the behavior I like, but I still
> wonder if a timezone feature on FAT is useful.  Also, would it not
> require the kernel to look up timezone info and keep track of DST
> changes? I thought the trend was to push that kind of thing into
> userland...

Yes. If it can do in userland (on embeded system too), it's very
good. (also, nls stuff is same situation.) But, I'm not sure yet,
need to think about it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
