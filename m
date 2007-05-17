Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbXEQExV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbXEQExV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbXEQExL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:53:11 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45322
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbXEQExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:53:09 -0400
Date: Wed, 16 May 2007 21:45:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Neil Brown <neilb@suse.de>
cc: Jeff Zheng <Jeff.Zheng@endace.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RE: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: <17995.49602.427417.500049@notabene.brown>
Message-ID: <Pine.LNX.4.64.0705162145060.31624@asgard.lang.hm>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
 <6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
 <17994.19043.771733.453896@notabene.brown> <659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
 <17995.42562.870806.396617@notabene.brown> <659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
 <17995.49602.427417.500049@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Neil Brown wrote:

> On Thursday May 17, Jeff.Zheng@endace.com wrote:
>>
>>> The only difference of any significance between the working
>>> and non-working configurations is that in the non-working,
>>> the component devices are larger than 2Gig, and hence have
>>> sector offsets greater than 32 bits.
>>
>> Do u mean 2T here?, but in both configuartion, the component devices are
>> larger than 2T (2.25T&5.5T).
>
> Yes, I meant 2T, and yes, the components are always over 2T.

2T decimal or 2T binary?

> So I'm
> at a complete loss.  The raid0 code follows the same paths and does
> the same things and uses 64bit arithmetic where needed.
>
> So I have no idea how there could be a difference between these two
> cases.
>
> I'm at a loss...
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
