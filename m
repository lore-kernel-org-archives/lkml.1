Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbXHALly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbXHALly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 07:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXHALlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 07:41:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30419 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbXHALlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 07:41:46 -0400
Message-ID: <46B0713E.5010700@oracle.com>
Date: Wed, 01 Aug 2007 17:10:46 +0530
From: gurudas pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joe Jin <joe.jin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, jens.axboe@oracle.com,
       lkml <linux-kernel@vger.kernel.org>, wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
References: <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com> <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com> <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com> <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com> <20070731153410.fcbf9a1b.akpm@linux-foundation.org> <alpine.LFD.0.999.0707311555410.4161@woody.linux-foundation.org> <20070801013632.GB10449@joejin-pc.cn.oracle.com>
In-Reply-To: <20070801013632.GB10449@joejin-pc.cn.oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Joe Jin wrote:
>> Does a patch like this work? I don't have any test-cases, but it would be 
>> good to have something like this tested and passed back with proper 
>> explanations and sign-offs.
>
> Yes it work find after apply the patch, thanks.
>
> Joe
I tried with Badari's and Linus's patch using same fio jobfile which 
earlier produced this oops.
And it works for me.

Thanks,
-Guru
