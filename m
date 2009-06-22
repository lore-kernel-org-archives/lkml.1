Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZFVTRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZFVTRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZFVTRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:17:45 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:62447 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZFVTRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=GShhdbwrU8+tiN4/qTj4pZeFeRKMcxsT/IxbujEyLmn8JP050FQp6XZOI+ilEoOpyc
         bfS8IBKoSqWsfFBkzXTaNiz5/pO1W+HmtjBVelaj0o/GpsYFCodEElyRcZbeRs+Upb/0
         ZdsLmxKY62o0IgmvCg0iC+e9Y9hSfjINIQrpw=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090622120018.GR24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622120018.GR24366@elte.hu>
Date: Mon, 22 Jun 2009 21:17:45 +0200
Message-ID: <7c86c4470906221217qc2342bbve83c79ddee921616@mail.gmail.com>
Subject: Re: IV.3 - AMD IBS
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 2:00 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> 3/ AMD IBS
>>
>> How is AMD IBS going to be implemented?
>>
>> IBS has two separate sets of registers. One to capture fetch
>> related data and another one to capture instruction execution
>> data. For each, there is one config register but multiple data
>> registers. In each mode, there is a specific sampling period and
>> IBS can interrupt.
>>
>> It looks like you could define two pseudo events or event types
>> and then define a new record_format and read_format. That formats
>> would only be valid for an IBS event.
>>
>> Is that how you intend to support IBS?
>
> That is indeed one of the ways we thought of, not really nice, but
> then, IBS is really weird, what were those AMD engineers thinking
> :-)
>

What's your problem with IBS? You need to elaborate when you make
this kind of comments. Remember what we discussed back in December.
If hardware designers put that in, it's because they think it can deliver
value-add. It may be difficult to use, but it delivers interesting data.


> The point is - weird hardware gets expressed as a ... weird feature
> under perfcounters too. Not all hardware weirdnesses can be
> engineered away.
>
