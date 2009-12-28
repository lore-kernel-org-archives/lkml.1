Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZL1J7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZL1J7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZL1J7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:59:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64415 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZL1J7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wLrNpRZIKlH2lmEdz2xUSYfchrW1/fdDOp0lSg5npihS260pZbbCX1rPhDPH/XsrmO
         MhdaBa6mZ9Pn9nv9cU0WVuoenLuv8gH3CYA723oWftii9QIk/RHleomNhbqNny4e/D2F
         fkfX7RvvnCTpNkXg7fAVcxVzttsdbeIbAoyEM=
MIME-Version: 1.0
In-Reply-To: <20091228144302.864f2e97.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
	 <20091228134752.44d13c34.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091228143154.ec0431b5.minchan.kim@barrios-desktop>
	 <20091228144302.864f2e97.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 28 Dec 2009 18:59:30 +0900
Message-ID: <28c262360912280159r69612770j97e30c3948c88c92@mail.gmail.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 2:43 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 28 Dec 2009 14:31:54 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>> > BTW, how about counting ZERO page in smaps? Ignoring them completely sounds
>> > not very good.
>>
>> I am not use it is useful.
>>
>> zero page snapshot of ongoing process is useful?
>> Doesn't Admin need to know about zero page?
>> Let's admins use it well. If we remove zero page again?
>> How many are applications use smaps?
>> Did we have a problem without it?
>>
> My concern is that hiding indormation which was exported before.
> No more than that and no strong demand.
>
>
>> When I think of it, there are too many qeustions.
>> Most important thing to add new statistics is just need of customer.
>>
>> Frankly speaking, I don't have good scenario of using zero page.
>> Do you have any scenario it is valueable?
>>
> read before write ? maybe sometimes happens.
>
> For example. current glibc's calloc() avoids memset() if the pages are
> dropped by MADVISE (without unmap).
>
> Before starting zero-page works, I checked "questions" in lkml and
> found some reports that some applications start to go OOM after zero-page
> removal.
>
> For me, I know one of my customer's application depends on behavior of
> zero page (on RHEL5). So, I tried to add again it before RHEL6 because
> I think removal of zero-page corrupts compatibility.
>

Okay. I will repost the patch.

> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
