Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZD0KGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZD0KGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZD0KGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:06:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:52389 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbZD0KF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <20090427095946.GB12323@infradead.org>
References: <1240821139-7247-22-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-25-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-26-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-27-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-28-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-29-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-30-git-send-email-monstr@monstr.eu>
	 <1240821139-7247-31-git-send-email-monstr@monstr.eu>
	 <20090427095946.GB12323@infradead.org>
Date: Mon, 27 Apr 2009 20:05:59 +1000
Message-ID: <1d3f23370904270305x3a1f518br63fc77ba940841f1@mail.gmail.com>
Subject: Re: [PATCH 30/30] microblaze_mmu_v1: fcntl.h MMU update
From: John Williams <john.williams@petalogix.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Mon, Apr 27, 2009 at 7:59 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Apr 27, 2009 at 10:32:19AM +0200, monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/include/asm/fcntl.h |   14 ++++++++++++++
>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/microblaze/include/asm/fcntl.h b/arch/microblaze/include/asm/fcntl.h
>> index 46ab12d..b4d27f6 100644
>> --- a/arch/microblaze/include/asm/fcntl.h
>> +++ b/arch/microblaze/include/asm/fcntl.h
>> @@ -1 +1,15 @@
>> +#ifndef _ASM_MICROBLAZE_FCNTL_H
>> +#define _ASM_MICROBLAZE_FCNTL_H
>> +
>> +#ifndef __uClinux__
>> +
>> +#define O_DIRECTORY  040000 /* must be a directory */
>> +#define O_NOFOLLOW   0100000 /* don't follow links */
>> +#define O_LARGEFILE  0200000
>> +#define O_DIRECT     0400000 /* direct disk access hint */
>> +
>> +#endif /* __uClinux__ */
>> +
>>  #include <asm-generic/fcntl.h>
>
> Again, ABIs should always be the same for MMU vs noMMU.

Is there a reason you need these custom fcntls?  What if you rebuild
glibc against the newer kernel headers (without __uClinux__)?

John
