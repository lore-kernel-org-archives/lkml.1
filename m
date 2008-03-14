Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYCNWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYCNWrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYCNWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:47:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:51621 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbYCNWrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CqKHI7u2yulZ1svf3kSDN9KFuXDt3ACcahroLJrBLtxKgAzDtadDnW5RxzvE+VDGUwOdPuZdRyEE8zgQ0uD4kz+6aK1LWzqhHaps4E/jidEmT4qEJJjVBckhAp8adckMQcCMMujW8U3m9PC089dxudGqXHgzGLvxC4Fjnfwy3Jo=
Message-ID: <b647ffbd0803141547s55fa37a1j5af4e50388d3117f@mail.gmail.com>
Date: Fri, 14 Mar 2008 23:47:05 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH] sched: fix race in schedule
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       hpj@urpla.net, stable <stable@kernel.org>
In-Reply-To: <47DABCE0.2070505@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D57770.50909@ct.jp.nec.com> <1205181256.6241.320.camel@lappy>
	 <47D5EA9C.1040404@ct.jp.nec.com> <1205224835.8514.183.camel@twins>
	 <47D6BD0C.6070401@ct.jp.nec.com>
	 <b647ffbd0803111638sdc92903r7faad3d4b2b6b842@mail.gmail.com>
	 <1205328457.8514.244.camel@twins>
	 <b647ffbd0803120748x2bfc8fbctda15ce3df08fcf5b@mail.gmail.com>
	 <1205333829.8514.249.camel@twins> <47DABCE0.2070505@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/2008, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
>
> [ ... ]
>
>  >> But maybe there is something esle that would be exposed by the
>  >> 'rq->curr = rq->idle' manipulation... I can't provide examples right
>  >> now though (I need to think on it).
>  >
>  > I share your concerns, I don't really like it either. Just spewing out
>  > ideas here - bad ideas it seems :-/
>  >
>  > Ingo also suggested moving the balance calls right before
>  > deactivate_task(), but that gives a whole other set of head-aches.
>  >
>
>
> Well, what will we do about this issue?
>  I see you're thinking to fix inconsistency in scheduler, right?
>  I agree about it.
>
>  However, I don't think it's good to remain this issue long time in
>  the -stable kernel.
>
>  Could you please let me know what I can do?

IMHO, the safest solution for the time being (and esp. for -stable)
would be to proceed with Hiroshi's patch. It looks safe and it does
fix a real problem.


>
> Hiroshi Shimamoto
>

-- 
Best regards,
Dmitry Adamushko
