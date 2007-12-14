Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbXLNXGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbXLNXGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933124AbXLNXG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:06:29 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:4623 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbXLNXG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:06:27 -0500
Message-ID: <47630C3B.602@chelsio.com>
Date: Fri, 14 Dec 2007 15:05:31 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>, wenxiong@us.ibm.com
Subject: Re: [PATCH 2/2] cxgb3 - Parity initialization for T3C adapters
References: <20071205181527.22106.73134.stgit@speedy5> <4759A6EA.1050106@garzik.org> <4759CD92.2070604@chelsio.com> <4759D6AF.5050205@garzik.org> <4759E200.3050607@chelsio.com>
In-Reply-To: <4759E200.3050607@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2007 23:04:14.0468 (UTC) FILETIME=[A5595440:01C83EA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> Jeff Garzik wrote:
>>
>> Divy Le Ray wrote:
>> > Jeff Garzik wrote:
>> >> Divy Le Ray wrote:
>> >>> From: Divy Le Ray <divy@chelsio.com>
>> >>>
>> >>> Add parity initialization for T3C adapters.
>> >>>
>> >>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>> >>> ---
>> >>>
>> >>>  drivers/net/cxgb3/adapter.h       |    1
>> >>>  drivers/net/cxgb3/cxgb3_main.c    |   82 ++++++++++++
>> >>>  drivers/net/cxgb3/cxgb3_offload.c |   15 ++
>> >>>  drivers/net/cxgb3/regs.h          |  248
>> >>> +++++++++++++++++++++++++++++++++++++
>> >>>  drivers/net/cxgb3/sge.c           |   24 +++-
>> >>>  drivers/net/cxgb3/t3_hw.c         |  131 +++++++++++++++++---
>> >>>  6 files changed, 472 insertions(+), 29 deletions(-)
>> >>
>> >> dropped patches 2-3, did not apply
>> >>
>> >>
>> >
>> > Hi Jeff,
>> >
>> > I noticed that you applied the first one of this 3 patches series 
>> to the
>> > #upstream-fixes branch.
>> > These patches are intended to the #upstream (2.6.25) branch, as 
>> they are
>> > built on top of the
>> > last 10 patches committed - 9 from me, and the white space clean up
>> > (thanks!).
>> > May be this is the reason why they did not apply.
>>
>> Ah... you need to tell me these things.  I looked for a kernel version
>> in your messages but did not see one.
>>
> I had put it in the introduction mail, I should have added the kernel 
> version in the patch titles.
> I'll do from now on.
>
>>
>> Does the patch #1 need to be reverted for 2.6.24?
>>
> No, it can be applied to 2.6.24.
> The 2 next patches seem to apply cleanly on #upstream when patch #1 is 
> popped out the patch stack.
>
Hi Jeff,

Did you get a chance to apply these patches #upstream ?

Cheers,
Divy


