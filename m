Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYHTOtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYHTOtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYHTOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:49:09 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:52220 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYHTOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MomKPoR/WDVMq2dhElGanleIxC/qNz9uyWaLY0IwBG7m++HFPfbvI+3HwlJx/djRUz
         7iEHDx103vC5h1AJFw1aBfKA4ll9/oW6CZ8GWvyPFcFKQWIEUJs1YVX886ofZgqUdtPT
         R192oW+8M31Cq1g5o5lYYYYP3Vc4Cpn4QdXZM=
Message-ID: <2f11576a0808200749x956cc3fsef5d0eeace243410@mail.gmail.com>
Date: Wed, 20 Aug 2008 23:49:06 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       tokunaga.keiich@jp.fujitsu.com
In-Reply-To: <48AC25E7.4090005@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48AC25E7.4090005@linux-foundation.org>
X-Google-Sender-Auth: e8b071224b1e3200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you very quick responce.

>> Thank you for explain your quicklist plan at OLS.
>>
>> So, I made summary to issue of quicklist.
>> if you have a bit time, Could you please read this mail and patches?
>> And, if possible, Could you please tell me your feeling?
>
> I believe what I said at the OLS was that quicklists are fundamentally crappy
> and should be replaced by something that works (Guess that is what you meant
> by "plan"?). Quicklists were generalized from the IA64 arch code.

Unfortunately, Multiple ia64 customer of my campany are suffered by
Quicklist, now.
because Quicklist works well for HPC likes application, but business
server's application has very different behavior.
IOW, Quicklist works well on best case, but it doesn't concern to worst case.

So, if possible, I'd like to make short term solution.
I believe nobody oppose quicklist reducing. it is defenitly too fat.

> Good fixup but I would think that some more radical rework is needed.
> Maybe some of this needs to vanish into the TLB handling logic?

What do you think wrong TLB handing?
pure performance issue?

> Then I have thought for awhile that the main reason that quicklists exist are
> the performance problems in the page allocator. If you can make the single
> page alloc / free pass competitive in performance with quicklists then we
> could get rid of all uses.

Agreed.
Do you have any page allocator enhancement plan?
Can I help it?
