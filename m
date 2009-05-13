Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbZEML6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbZEML6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZEML6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:58:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:16656 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZEML6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qDXilCWX2ns/5t8pzZNHHQoaupnp85+QmPfV/aBw8ctWxYoMPs2BC84aPXTxsxj9Vs
         17sxfFzLB5Jg42dg4Ql9yZFRPdVflMa6zKJxw98peMrr7UX9dzThQYYa3tI7F5tejjEn
         YE1fBRBYLBGASYM6giQ+ZNbrXI3Edpf5vHkNk=
MIME-Version: 1.0
In-Reply-To: <20090513113817.GO19296@one.firstfloor.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	 <87r5ytl0nn.fsf@basil.nowhere.org>
	 <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com>
	 <20090513113817.GO19296@one.firstfloor.org>
Date: Wed, 13 May 2009 20:58:20 +0900
X-Google-Sender-Auth: 5347c320c4183f60
Message-ID: <2f11576a0905130458x2e56e952ga47216da42b30906@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED 
	submenu
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In past days, I proposed this. but Minchan found this config bloat kernel 7kb
>> and he claim embedded guys should have selectable chance. I agreed it.
>
> Well there's lots of code in the kernel and 7k doesn't seem worth bothering.
> If you just save two pages of memory somewhere you can save more.
>
>> Is this enough explanation?
>
> It's not a very good one.
>
> I would propose to just remove it or at least hide it completely
> and only make it dependent on CONFIG_MMU inside Kconfig.

hm, if minchan ack this, I can remove this option completely.
but I dislike dpend on CONFIG_MMU. it because

1. this featuren don't depend CONFIG_MMU. that's bogus.
2. I don't test !MMU easily rather than MMU. IOW it make code quality risk.
