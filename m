Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXBSWTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXBSWTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbXBSWTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:19:14 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1620 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbXBSWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:19:13 -0500
X-AuthUser: hirofumi@parknet.jp
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org>
	<87vehzqwf6.fsf@duaron.myhome.or.jp>
	<04C493C2-1D8D-41B7-955A-F5C5B08023BB@kernel.crashing.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 20 Feb 2007 07:19:06 +0900
In-Reply-To: <04C493C2-1D8D-41B7-955A-F5C5B08023BB@kernel.crashing.org> (Kumar Gala's message of "Mon\, 19 Feb 2007 15\:58\:53 -0600")
Message-ID: <87ejolkcyt.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@kernel.crashing.org> writes:

>>> I usually run the following twice to get the hang state:
>>>
>>> time ./trunc_test bar 100000000 &
>>> time ./trunc_test baz 100000000 &
>>>
>>> I was wondering if anyone had any suggestions on what to poke at next
>>> to try and figure out what is going on.
>>
>> Can you check /sys/block/xxx/stat or something to make sure there is
>> no outstanding IO request?
>>
>> It seems to be no response from the lower layer...
>
> Once the system locks up I dont have any ability to do anything.

Ah, doesn't sysrq also work? If sysrq work, it can use to see IO
request state with a patch.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
