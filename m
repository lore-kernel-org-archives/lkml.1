Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYJEFst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYJEFst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 01:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYJEFsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 01:48:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:57950 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYJEFsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 01:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NF+oGi9DfS+MImgTdohaH47hspv3nxklyZuCYi7xpb8bhcYjMlrzuef1J+jMYgDOHu
         TcgdpunIkwA6634N6BdoxDppYZNSYQEUv84nEU2okDP/ujiblAQycCwmmJAtnCq4gS4h
         8/rL4UTKcX5+4wn/Kjh6orITjKKeTalcc4G7s=
Message-ID: <2f11576a0810042248v209cae42m3ed280f0489b8a0@mail.gmail.com>
Date: Sun, 5 Oct 2008 14:48:39 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [RFC PATCH] Report the shmid backing a VMA in maps
Cc: "Mel Gorman" <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Adam Litke" <agl@us.ibm.com>
In-Reply-To: <20081004215228.GA20048@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie>
	 <1223052415-18956-3-git-send-email-mel@csn.ul.ie>
	 <20081004205650.CE47.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081004215228.GA20048@x200.localdomain>
X-Google-Sender-Auth: adc522ca2cf617f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/5 Alexey Dobriyan <adobriyan@gmail.com>:
> On Sat, Oct 04, 2008 at 09:04:03PM +0900, KOSAKI Motohiro wrote:
>> In the other hand, huge page is often used via ipc shm, not mmap.
>> So, administrator often want to know relationship of memory region and shmid.
>>
>> Then, To add shmid attribute in /proc/{pid}/maps is useful.
>>
>>
>> In addition, shmid information is not only useful for huge page, but also for normal shm.
>> Then, this patch works well on normal shm.
>
>> 2000000000500000-2000000000900000 rw-s 00000000 00:09 0                  /SYSV00000000 (deleted) (shmid=0)
>> 2000000000900000-2000000000d00000 rw-s 00000000 00:09 32769              /SYSV00000000 (deleted) (shmid=32769)
>                                                        ^^^^^                                             ^^^^^
>
> shmid is already in place, and no, it's not a coincidence ;-)

Oops, Thanks very good information.
I'll drop this patch :)
