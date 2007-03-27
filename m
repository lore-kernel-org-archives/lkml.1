Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXC0JyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXC0JyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXC0JyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:54:17 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:1461 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbXC0JyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:54:16 -0400
From: Paul Collins <paul@briny.ondioline.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hiroyuki Machida <Hiroyuki_Machida@hq.scei.sony.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat/vfat: optionally ignore system timezone offset when reading/writing timestamps
References: <OFE734E183.0E10CA2B-ON492572AA.00132685-492572AA.0016700F@hq.scei.sony.co.jp>
	<87ps6whvh5.fsf@duaron.myhome.or.jp>
Date: Tue, 27 Mar 2007 21:52:57 +1200
In-Reply-To: <87ps6whvh5.fsf@duaron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue\, 27 Mar 2007 00\:31\:50 +0900")
Message-ID: <87fy7rrp1i.fsf@briny.internal.ondioline.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Hiroyuki Machida <Hiroyuki_Machida@hq.scei.sony.co.jp> writes:
>
>> I'm not famillar with recent fat code, but code itself looks good for
>> just turn on/off time adjusting. On the other hand, I feel we need more 
>> consideration on use cases/requirements. I feel that turning off
>> time adjustment is a just ad-hoc solution to issues like Paul san 
>> brought up.
>
> Thank you. I see. So we need "timezone" option to specify adjusted
> time?  If so, I feel we can add it as "timezone=utc", then it'll can
> be improved later...

I am happy to change the patch as needed.  However, since the kernel
does not have access to a timezone database and therefore cannot
convert timezone names to offsets, perhaps the mount option should be
something like "tzoffset=0", "tzoffset=1200" etc., with "tzoffset=0"
being equivalent to the "posixtime" option implemented by my patch.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
