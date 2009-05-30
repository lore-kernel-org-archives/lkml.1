Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbZE3Lig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbZE3Lig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZE3Li3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:38:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:1767 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZE3Li2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IIaGpFt69+gGpuNVECHmmWJ1FEw/lPd6gzLqgaIsfztsvN+ynnk8Aw3qM8ISMKTQQp
         q1D8UHfu/2lUbqLjZYOJ7v9xXMC1w2j2Io4HEpbzoSBVZwuwgnztAjTqu8TVJJ/hGuQ7
         Zh9htSuSAwqLZMX2R5wpRVkSPvo64sbfs0Kj8=
MIME-Version: 1.0
In-Reply-To: <20090508091052.GA10429@januz.myftp.org>
References: <164c92d827cbee86ba2c5621716309e6@localhost>
	 <200904300939.31754.henrik@austad.us>
	 <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
	 <20090508091052.GA10429@januz.myftp.org>
Date: Sat, 30 May 2009 20:38:29 +0900
Message-ID: <49b7c2350905300438n6195de93la53bee3a309f71d@mail.gmail.com>
Subject: Re: SCHED_EDF infos
From: GeunSik Lim <leemgs1@gmail.com>
To: Henrik Austad <henrik@austad.us>
Cc: finarfin@dreamos.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 6:10 PM, Henrik Austad <henrik@austad.us> wrote:
>> [..]
>> I think so.
>> How can we approach  EDF implementation like Pfair as a generic solution
>> for Multicore in Linux?
>
> I am working on an implementation now, and I hope to be able to release a
> prototype by the end of next week. I think we can continue the discussion
> then based on that.
Hi Henrik,
Can you share EDF that you implemented with P-fair for Multicore environments?
Especially, I wonder How do you keep posix compatibility with EDF scheduler.

For example,
sched_setscheduler(2), sched_getscheduler(2),
sched_get_priority_max(2), sched_get_priority_min(2),
sched_getaffinity(2), sched_setaffinity(2),
sched_getparam(2), sched_setparam(2),
setpriority(2), getpriority(2),
sched_yield(2), sched_rr_get_interval(2)


-- 
Regards,
GeunSik Lim ( SAMSUNG ELECTRONICS)
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
