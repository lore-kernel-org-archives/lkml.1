Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYFYHhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYFYHhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYFYHha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:37:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:16114 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYFYHh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uMoY1rOhU1tImVW3H8gFu3Fg481pxqZS5+e7uNNswIkwzjN/AVM14VTshwEke8yN2X
         IBh0L8UlJu3yygNXjYD1GPGtrVFs/7yf1TkUAMoBLAYVY7mVhGTtdqT0WPohTYLmfuX/
         SM9j4az58o1/hFy+w0oBuTRVZTHYmPwGezwt8=
Message-ID: <28c262360806250037k9fcde73g9b28c26eb8523f04@mail.gmail.com>
Date: Wed, 25 Jun 2008 16:37:29 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Cc: "Rik van Riel" <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>
In-Reply-To: <20080625161753.D848.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <28c262360806242356n3f7e02abwfee1f6acf0fd2c61@mail.gmail.com>
	 <28c262360806242358q348e18a4vb9c48b4b853b0384@mail.gmail.com>
	 <20080625161753.D848.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 4:29 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > But if such emergency happen in embedded system, application can't be
>> > executed for some time.
>> > I am not sure how long time it take.
>> > But In some application, schedule period is very important than memory
>> > reclaim latency.
>> >
>> > Now, In your patch, when such emergency happen, it continue to reclaim
>> > page until it will scan entire page of lru list.
>> > It
>>
>> with my mistake, I omit following message. :(
>>
>> So, we need cut-off mechanism to reduce application latency.
>> So In my opinion, If we modify some code of Takenori's patch, we can
>> apply his idea to prevent latency probelm.
>
> Yup.
> Agreed with latency is as important as throughput.
>
> if anyone explain that patch have reduce some latency and
> no throughput degression by benchmark result,
> I have no objection, Of cource.
>
> Can you post any performance result?
>
>

hm.. I am not sure when I can post result of benchmark.

Of course, If I do, I will post it :)

Thanks, Kosaki-san

-- 
Kinds regards,
MinChan Kim
