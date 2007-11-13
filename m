Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXKMEnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXKMEnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbXKMEng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:43:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:55932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbXKMEnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:43:35 -0500
Message-ID: <47392B71.5000009@suse.de>
Date: Tue, 13 Nov 2007 13:43:29 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: fix  off-by-one error in fill_read_buffer
References: <4732EDD2.2050406@cn.fujitsu.com> <47385E4A.5030306@suse.de> <47391EFA.4000004@cn.fujitsu.com>
In-Reply-To: <47391EFA.4000004@cn.fujitsu.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miao Xie wrote:
> on 2007-11-12 22:08 Tejun Heo wrote:
>> It isn't strictly a bug.  If the ->show() op fills full PAGE_SIZE and
>> returns PAGE_SIZE, the user will get full PAGE_SIZE bytes correctly, so
>> it will work.  However, considering normal use cases, return value of
>> PAGE_SIZE very likely indicates an error condition, so considering it a
>> BUG condition is a good idea.
>>
>> Miao, can you please note that the code works fine with PAGE_SIZE return
>> but it's likely to indicate truncated result or overflow in normal use
>> cases as a comment on top of the BUG_ON()?
>>
>> Thanks.
> 
> OK, I did it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Acked-by: Tejun Heo <htejun@gmail.com>

Greg, can you please push this one?  Thanks.

-- 
tejun
