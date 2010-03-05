Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0CET2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:28:42 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62976 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0CET2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:28:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Iaf6Kic/exT+WrvDclZOmKrz4PmrSeqP2FWn5f+2bDlIiLZD6Vz/gJbhEhmc66LJw
	noez9tlpyLylVxUAn/I2A==
MIME-Version: 1.0
In-Reply-To: <1267816553.4942.6.camel@laptop>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
	 <1267816553.4942.6.camel@laptop>
Date: Fri, 5 Mar 2010 11:28:36 -0800
Message-ID: <bd4cb8901003051128l67a52d38h17208ec340b86c4e@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 11:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-03-05 at 10:58 -0800, Stephane Eranian wrote:
>> >        case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
>> > +               x86_pmu.quirks = intel_clowertown_quirks;
>>
>> That's too coarse grain!
>> It is more subtle than this. Some of the errata are marked as Plan
>> fix. They seem to be
>> fixed in later models. Your looking at the E5xxx series errata but the
>> E7xxx do not have
>> the same problems.
>
> OK, I'll look at those errata again and try to come up with a stepping
> test for this errata.
>
There is erratum which you need to implement the workaround for and
this is AAJ91 on Nehalem. It does happen.
