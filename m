Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZD0K4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZD0K4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZD0K4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:56:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:46477 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZD0K4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:56:12 -0400
Message-ID: <49F58F49.3010001@monstr.eu>
Date: Mon, 27 Apr 2009 12:56:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/30] microblaze_mmu_v1: fcntl.h MMU update
References: <1240821139-7247-22-git-send-email-monstr@monstr.eu>	 <1240821139-7247-24-git-send-email-monstr@monstr.eu>	 <1240821139-7247-25-git-send-email-monstr@monstr.eu>	 <1240821139-7247-26-git-send-email-monstr@monstr.eu>	 <1240821139-7247-27-git-send-email-monstr@monstr.eu>	 <1240821139-7247-28-git-send-email-monstr@monstr.eu>	 <1240821139-7247-29-git-send-email-monstr@monstr.eu>	 <1240821139-7247-30-git-send-email-monstr@monstr.eu>	 <1240821139-7247-31-git-send-email-monstr@monstr.eu>	 <20090427095946.GB12323@infradead.org> <1d3f23370904270305x3a1f518br63fc77ba940841f1@mail.gmail.com>
In-Reply-To: <1d3f23370904270305x3a1f518br63fc77ba940841f1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Williams wrote:
> Michal,
> 
> On Mon, Apr 27, 2009 at 7:59 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, Apr 27, 2009 at 10:32:19AM +0200, monstr@monstr.eu wrote:
>>> From: Michal Simek <monstr@monstr.eu>
>>>
>>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>> ---
>>>  arch/microblaze/include/asm/fcntl.h |   14 ++++++++++++++
>>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/microblaze/include/asm/fcntl.h b/arch/microblaze/include/asm/fcntl.h
>>> index 46ab12d..b4d27f6 100644
>>> --- a/arch/microblaze/include/asm/fcntl.h
>>> +++ b/arch/microblaze/include/asm/fcntl.h
>>> @@ -1 +1,15 @@
>>> +#ifndef _ASM_MICROBLAZE_FCNTL_H
>>> +#define _ASM_MICROBLAZE_FCNTL_H
>>> +
>>> +#ifndef __uClinux__
>>> +
>>> +#define O_DIRECTORY  040000 /* must be a directory */
>>> +#define O_NOFOLLOW   0100000 /* don't follow links */
>>> +#define O_LARGEFILE  0200000
>>> +#define O_DIRECT     0400000 /* direct disk access hint */
>>> +
>>> +#endif /* __uClinux__ */
>>> +
>>>  #include <asm-generic/fcntl.h>
>> Again, ABIs should always be the same for MMU vs noMMU.
> 
> Is there a reason you need these custom fcntls?  What if you rebuild
> glibc against the newer kernel headers (without __uClinux__)?

here is situation a little bit cleaner than stat64 issue. This should be definitely
removed for merging.I need more time for test.

Thanks,
Michal

> 
> John


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
