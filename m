Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbZEMLld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbZEMLld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZEMLlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:41:22 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:39273 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZEMLlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GwcCzVgmqpZRZGEz5KKDdEP7P5pGCwTtFEUa5hQRT0fOZfY6H9Fw7T5dwJBnRtJ7t7
         kgnGJjb4/iIbpCTrJJFuBibyJwKlsUQJ7XlvOkH1ITNft5tMCaXlQ+v4BCoRc/1r1LZf
         eeJB+u4ZTT39xIrm5yFxQwwUyRlqrb2CJFZZs=
MIME-Version: 1.0
In-Reply-To: <20090513113817.GO19296@one.firstfloor.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	 <87r5ytl0nn.fsf@basil.nowhere.org>
	 <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com>
	 <20090513113817.GO19296@one.firstfloor.org>
Date: Wed, 13 May 2009 20:41:21 +0900
Message-ID: <28c262360905130441q8c904faq1d3e5152fada7a85@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED 
	submenu
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi.

On Wed, May 13, 2009 at 8:38 PM, Andi Kleen <andi@firstfloor.org> wrote:
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

I thought this feature don't have a big impact on embedded.
At First, 7K is not important but as time goes by, it could be huge
with very small size feature for server or desktop.

So I wanted to add it with optionally. :)

In future, embedded also have a big ram then we can remove optional
config completely, I think.


> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
Minchan Kim
