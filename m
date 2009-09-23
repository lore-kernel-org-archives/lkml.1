Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZIWMUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZIWMUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZIWMUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:20:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:27775 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZIWMUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m9oTvtrNVYmaIjq4TVGqlsn6wvllI1sVNx7ALY86FQvV3wJNbmQCtjnZwhY9Lo9H1U
         j2mpDTNGagrSUqlFye8LdksWKXnsebWpq7llpXyrUzNVTF8kO1DRggmRaI2dAVJDJhoH
         3atagh/gIWtHOGvoFUXn+m8EiibpbRJaJ4qgM=
MIME-Version: 1.0
In-Reply-To: <20090923114258.GA4132@elte.hu>
References: <20090923073253.GA18022@elte.hu>
	 <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com>
	 <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
	 <7863dc4c0909230215u2fed3edciec84f93f24d3ae1@mail.gmail.com>
	 <20090923092024.GA29323@elte.hu>
	 <aa79d98a0909230248j22f05047n34e0ee97382f573f@mail.gmail.com>
	 <7863dc4c0909230306x3bc60775rc503919df83087ed@mail.gmail.com>
	 <20090923104244.GB23941@elte.hu>
	 <7863dc4c0909230441p49b7440bu9de9f786fee9c4bd@mail.gmail.com>
	 <20090923114258.GA4132@elte.hu>
Date: Wed, 23 Sep 2009 13:20:47 +0100
X-Google-Sender-Auth: 9b2774a72aebcb85
Message-ID: <7863dc4c0909230520o8338114uf63b9d5e6f4b6c4e@mail.gmail.com>
Subject: Re: perf sched record hangs machine
From: Chris Malley <mail@chrismalley.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/23 Ingo Molnar <mingo@elte.hu>:
>
> * Chris Malley <mail@chrismalley.co.uk> wrote:
>
>> 2009/9/23 Ingo Molnar <mingo@elte.hu>:
>> >
>> > * Chris Malley <mail@chrismalley.co.uk> wrote:
>> >
>> >> Applied Peter's patch, doesn't seem to have fixed the problem:
>> >>
>> >> [ ?246.408893] BUG: unable to handle kernel paging request at ffffb300
>> >> [ ?246.408939] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
>> >
>> > could you please send the full bootlog, up to the crash?
>> >
>> > Thanks,
>> >
>> > ? ? ? ?Ingo
>> >
>>
>> Sure, but I'm just rebuilding from clean first in case the change
>> wasn't picked up for some reason, because I don't see how it can get
>> to default_send_IPI_self() in my configuration...
>
> yeah - i have that thinking too - according to your earlier boot
> messages x86_pmu.apic must be 0 and that codepath shouldnt trigger.
>
>        Ingo
>

Yep, my bad.  The build process had helpfully appended a -dirty tag to
the kernel version which I hadn't noticed.

I can't make it hang any more, so the fix looks good to me, thanks everyone.

Chris
