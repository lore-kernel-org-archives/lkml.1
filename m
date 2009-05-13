Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbZEMMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbZEMMMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZEMMMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:12:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:22475 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZEMMMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r+4Ug7FiCJopAMUp4qZEkbaKyf+xJdU5o2PkbH+EdLtt0vbQRzdrxiPgsoAiCdZHQ4
         x4B5IXNewZJoUtweNB6kSZZjUkgQ3raqZKZ5i7AxSPaxdagajBnL/YD1BVsE+ybtVxCT
         bplNQ1BHGO+opTqxGuR7q9IDUCgTAw0LKzQjc=
MIME-Version: 1.0
In-Reply-To: <2f11576a0905130458x2e56e952ga47216da42b30906@mail.gmail.com>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	 <87r5ytl0nn.fsf@basil.nowhere.org>
	 <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com>
	 <20090513113817.GO19296@one.firstfloor.org>
	 <2f11576a0905130458x2e56e952ga47216da42b30906@mail.gmail.com>
Date: Wed, 13 May 2009 21:12:06 +0900
Message-ID: <28c262360905130512j6b6bab9dj847e17840120d8e9@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED 
	submenu
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 8:58 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>>> In past days, I proposed this. but Minchan found this config bloat kernel 7kb
>>> and he claim embedded guys should have selectable chance. I agreed it.
>>
>> Well there's lots of code in the kernel and 7k doesn't seem worth bothering.
>> If you just save two pages of memory somewhere you can save more.
>>
>>> Is this enough explanation?
>>
>> It's not a very good one.
>>
>> I would propose to just remove it or at least hide it completely
>> and only make it dependent on CONFIG_MMU inside Kconfig.
>
> hm, if minchan ack this, I can remove this option completely.

In fact, I expected this feature has to be disable with default.
But, David and Hannes already acked with enable with default.

It means they don't have a size concern, too.
Hmm. If I don't misunderstood their thought, I agree Andi's suggestion.

Thanks for good discussion. Andi!

-- 
Kinds regards,
Minchan Kim
