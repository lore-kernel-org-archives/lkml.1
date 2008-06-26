Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYFZRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYFZRrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYFZRrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:47:05 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:39460 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYFZRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:47:04 -0400
Message-ID: <4863D037.90504@skyrush.com>
Date: Thu, 26 Jun 2008 11:21:59 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com> <87zlp8w4br.fsf@devron.myhome.or.jp>
In-Reply-To: <87zlp8w4br.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> If so, I'd like to see "tz=xxx" or something for the future, instead of
> "utc", don't you think so? I really hate to add the random options.

One question: do you see the "tz=" option having "xxx" being a numerical
offset or a time zone.  If the latter, then the DST situation could be
solved (and tz=UTC could be used to get the behavior I like, but I still
wonder if a timezone feature on FAT is useful.  Also, would it not
require the kernel to look up timezone info and keep track of DST
changes?  I thought the trend was to push that kind of thing into
userland...

					Thanks, Joe
