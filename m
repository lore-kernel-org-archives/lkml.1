Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZAJSWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZAJSWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZAJSW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:22:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:9500 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZAJSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Bk/yyRO2sDK98vyJzr+jVu+04vydkDeG2gnIj4Y37izn1rkl2vtBdPHA639pLzEp9z
         sJP8qPuTkkFQDrN1rXTwpCyzRDDSe5aZ3Hau5VgZKvJTzc4qPKbHZJF+MlPWb+yHKfI5
         M7SBAWXzrQM/2T0iHmM0G1oPwkfY1/moHn4iM=
Message-ID: <51c5bc110901101022g1fc407f6ifc37aa93580a2da1@mail.gmail.com>
Date: Sat, 10 Jan 2009 10:22:25 -0800
From: kobayashi.kk@ncos.nec.co.jp
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com
In-Reply-To: <20090109141642.61540741.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp>
	 <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
	 <20081126190603.3CC3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090109141642.61540741.akpm@linux-foundation.org>
X-Google-Sender-Auth: 04ffea40ec4d2981
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/9 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 26 Nov 2008 19:10:28 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> nit
>>
>> > @@ -49,6 +50,10 @@ static int show_stat(struct seq_file *p, void *v)
>> >                     sum += kstat_irqs_cpu(j, i);
>> >
>> >             sum += arch_irq_stat_cpu(i);
>> > +
>> > +           for (j = 0; j < NR_SOFTIRQS; j++)
>> > +                   sum_softirq += kstat_softirqs_cpu(j, i);
>> > +
>> >     }
>>
>> You can calcurate per_irq_sum here.
>> Typically, # of possible cpu are very big.
>>
>> So, I don't like unnecessary twrice looping.
>
> I was about to send these patches to Linus, but it seems that this
> optmisation hasn't been addressed?

Thanks for your notice, Andrew.
Of course, thanks for your advice, Kosaki-san.
I didn't check carefully about this point...

Now I am on a business trip.
So, I'll post the fix next week.

// Keika Kobayashi
