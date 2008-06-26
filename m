Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYFZQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYFZQ0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYFZQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:26:06 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57544 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYFZQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:26:05 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Peterson <joe@skyrush.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>
	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>
	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com>
Date: Fri, 27 Jun 2008 01:26:00 +0900
In-Reply-To: <4863B9AF.4080105@skyrush.com> (Joe Peterson's message of "Thu,
	26 Jun 2008 09:45:51 -0600")
Message-ID: <87zlp8w4br.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> writes:

> I do not consider this modifying the design of FAT.  FAT does not have
> the concept of time zone, DST, or UTC.  It is just a date/time (stamped
> on the volume with no info about what that means).  It is customary to
> say these times are in local time, and Windows happens to use it as if
> it's straight local time (Linux tries to emulate this).  But using FAT
> to store UTC instead is not changing the design, it is just using it
> differently.  I agree this would not be a good idea when sharing a
> volume with Windows, but for cameras, e.g., why not?

UTC itself is not wrong. But, I think *"utc" option* is not way to go.

>> However, I can accept that hack for many broken devices on realworld,
>> but, the modifying design is not right option. Do you see what I want
>> to say?
>
> If it is a hack (and I do not consider it to be so), I still do not see
> why the utc option is a design change - how else would you get the
> desired behavior?

I think we agreed to fix sys_tz is good thing.

If so, I'd like to see "tz=xxx" or something for the future, instead of
"utc", don't you think so? I really hate to add the random options.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
