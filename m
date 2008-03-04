Return-Path: <linux-kernel-owner+w=401wt.eu-S1765308AbYCDQRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765308AbYCDQRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761843AbYCDQRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:17:33 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:8417 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbYCDQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=d1wjGI06rVy0ApjioqPo3MxP2tYB3F/JM0zLJcUsGC257BMm54DMc+7SOSoDWLn6jnU0BU6+Ai6Bp6jFfSPC9GJJiDwHCMKvF+NGdCP++kqUO1RLnDGPU5vdyC3hna3W+sDDuTjtcMuzod50yuF8Uep/ObTrKaULWHDZpOQsHZo=
Message-ID: <47CD7611.2030606@gmail.com>
Date: Wed, 05 Mar 2008 01:17:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304093536.GH6704@kernel.dk>	<1204634238.5997.5.camel@homer.simson.net>	<47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com>
In-Reply-To: <47CD53BA.5040908@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> FUJITA Tomonori wrote:
>>> Aiee... device going down after timing out on READ_DISC_INFO.  That's
>>> gruesome.  Can you please try the other patches?
>> Tejun, I thought that libata needs a fix for sum(sg) != rq->data_len. No?
> 
> The extra_len you added to qc->nbytes should be it.  The only other
> place to pay attention is the ATAPI transfer chunk size and your patch
> seems to get it right.
> 
>> Now Jens' git tree should work with all the non libata stuff, ide,
>> firewire, bsg, etc. But I'm not sure about libata.
> 
> With the second patch, all others should be fine no matter what.  I'll
> go check libata part again.

I can reproduce the problem here and it's very weird.  I'll report back
when I know more.

-- 
tejun
