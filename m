Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXC0Pk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXC0Pk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXC0Pk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:40:56 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1751 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXC0Pkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:40:55 -0400
X-AuthUser: hirofumi@parknet.jp
To: Paul Collins <paul@briny.ondioline.org>
Cc: Hiroyuki Machida <Hiroyuki_Machida@hq.scei.sony.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat/vfat: optionally ignore system timezone offset when reading/writing timestamps
References: <OFE734E183.0E10CA2B-ON492572AA.00132685-492572AA.0016700F@hq.scei.sony.co.jp>
	<87ps6whvh5.fsf@duaron.myhome.or.jp>
	<87fy7rrp1i.fsf@briny.internal.ondioline.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 28 Mar 2007 00:40:44 +0900
In-Reply-To: <87fy7rrp1i.fsf@briny.internal.ondioline.org> (Paul Collins's message of "Tue\, 27 Mar 2007 21\:52\:57 +1200")
Message-ID: <873b3qheyr.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins <paul@briny.ondioline.org> writes:

> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> Thank you. I see. So we need "timezone" option to specify adjusted
>> time?  If so, I feel we can add it as "timezone=utc", then it'll can
>> be improved later...
>
> I am happy to change the patch as needed.  However, since the kernel
> does not have access to a timezone database and therefore cannot
> convert timezone names to offsets, perhaps the mount option should be
> something like "tzoffset=0", "tzoffset=1200" etc., with "tzoffset=0"
> being equivalent to the "posixtime" option implemented by my patch.

Looks sane. The mount command would be able to convert the string
timezone to it if needed.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
