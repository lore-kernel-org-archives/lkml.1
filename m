Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbZFQR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbZFQR2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbZFQR2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:28:01 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53557 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967AbZFQR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:28:01 -0400
To: Daniel Walker <dwalker@fifo99.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Rename kmemleak_panic to kmemleak_stop
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	<20090616223649.719ea378.akpm@linux-foundation.org>
	<20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	<1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	<20090617122803.GD28529@csn.ul.ie>
	<1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	<20090617124034.GE28529@csn.ul.ie>
	<1245243130.11889.27.camel@pc1117.cambridge.arm.com>
	<84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
	<1245245007.11889.42.camel@pc1117.cambridge.arm.com>
	<1245245448.5604.31.camel@penberg-laptop>
	<1245253019.11889.55.camel@pc1117.cambridge.arm.com>
	<1245258862.5982.264.camel@desktop>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 17 Jun 2009 18:27:19 +0100
In-Reply-To: <1245258862.5982.264.camel@desktop> (Daniel Walker's message of "Wed\, 17 Jun 2009 10\:14\:22 -0700")
Message-ID: <tnxy6rqsrd4.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jun 2009 17:27:22.0446 (UTC) FILETIME=[DFA7C6E0:01C9EF70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> wrote:
> On Wed, 2009-06-17 at 16:36 +0100, Catalin Marinas wrote:
>> This is to avoid the confusion created by the "panic" word.
>> 
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>> 
>> (following Pekka's suggestion)
>> 
>>  mm/kmemleak.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>> index 25e2034..c1f538e 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -251,7 +251,7 @@ static void kmemleak_disable(void);
>>   * recovered from. Kkmemleak will be disabled and further allocation/freeing
>>   * tracing no longer available.
>
> Looks like there's a little typo up there, "Kkmemleak" should be
> "kmemleak" no ?

It seems that there are more places like this. I'll add a patch.

Thanks.

-- 
Catalin
