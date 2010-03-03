Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0CCGQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:16:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0CCGQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:16:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XJ5NNfARAtzSXk5+xZDKuzRJR0zJZJ3qZmCkiqUpUOq2xk0hcxKZgL1qSmkof5jLo
	xVkdXmJYnm2NTmUlLypew==
MIME-Version: 1.0
In-Reply-To: <1267552492.25158.71.camel@laptop>
References: <tip-b622d644c7d61a5cb95b74e7b143c263bed21f0a@git.kernel.org>
	 <bd4cb8901003020826w6540ffebje2cee53b52f1ff27@mail.gmail.com>
	 <1267552492.25158.71.camel@laptop>
Date: Tue, 2 Mar 2010 22:16:26 -0800
Message-ID: <bd4cb8901003022216u281d279ak5d9933f5da3bb6e6@mail.gmail.com>
Subject: Re: [tip:perf/core] perf_events, x86: Fixup fixed counter constraints
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 9:54 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-03-02 at 17:26 +0100, Stephane Eranian wrote:
>> > @@ -37,14 +43,16 @@ static struct event_constraint intel_core2_event_constraints[] =
>> >        INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
>> >        INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
>> >        INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
>> > +       INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */
>>
>> Where does the constraint on ITLB_MISS_RETIRED come from?
>
> Intel® 64 and IA-32 Architectures Software Developer’s Manual
> Volume 3B: System Programming Guide, Part 2
>
> Dec 2009 (253669)
>
> Section 30.4.3, Table 30-9
>
I am not so sure about this one. I will double check.
