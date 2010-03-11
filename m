Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CKVJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:09:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51237 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0CKVJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:09:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=P1ir6gRQYns6h8q5YFN2t+K70QV+0oXET6bMWFrzodZqFwTOorczZoQdka2zYlQDV
	iS4HNUBms3gYyqgbORBhA==
MIME-Version: 1.0
In-Reply-To: <1268341655.5037.138.camel@laptop>
References: <1268341168-19705-1-git-send-email-eranian@google.com>
	 <1268341655.5037.138.camel@laptop>
Date: Thu, 11 Mar 2010 13:09:26 -0800
Message-ID: <bd4cb8901003111309q57e9e2efo37bd4bc9057216b2@mail.gmail.com>
Subject: Re: [PATCH] perf_events: remove bogus Intel Core constraint on 
	ITLB_MISS_RETIRED
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 1:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-03-11 at 12:59 -0800, eranian@google.com wrote:
>> Contrary to what Vol3b section 30.4.3 leads to believe, there is
>> no constraint on ITLB_MISS_RETIRED on Intel Core-based CPU, so
>> remove it.
>
> Is that from Intel, and will they clarify the text in the next version
> of the document?
>
Yes.

>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> --
>>  perf_event_intel.c |    1 -
>>  1 file changed, 1 deletion(-)
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>> index 971dc6e..58e83cd 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -43,7 +43,6 @@ static struct event_constraint intel_core2_event_constraints[] =
>>       INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
>>       INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
>>       INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
>> -     INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */
>>       INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
>>       EVENT_CONSTRAINT_END
>>  };
>
>
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
