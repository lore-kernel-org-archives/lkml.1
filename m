Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYHHLxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYHHLxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYHHLw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:52:56 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:42958 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYHHLwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=waP+3HbEc5vbqayatbVTdGm+zWTsYqmC4O2x7KcGVEk4UvIDoIP2jJLi2OO1AHAjog
         RGJzltFWa19jByi5cCC0bM5zTaX+ysLIL+O103UpZUevb2sYAueq+GUajBPzehGk6TNt
         y7Ft25k30R5g9PETvl/P45+o2+Oqgq4O/jiPQ=
Message-ID: <a4423d670808080452u2833418agc8027dfc33c9bb18@mail.gmail.com>
Date: Fri, 8 Aug 2008 15:52:53 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: mikpe@it.uu.se, kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080808.041814.41687650.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670808080314weed9178o9f9ef52803a68501@mail.gmail.com>
	 <20080808.033811.129671951.davem@davemloft.net>
	 <a4423d670808080356r6573102am8a1eb9dcc83910c8@mail.gmail.com>
	 <20080808.041814.41687650.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 David Miller <davem@davemloft.net>:
> This will allow you to see the crash message.
Yes, I saw it.
There were few WARNINGS at lib/list_debug.c:__list_add
That messages went fast, I can not see it now.
Now I see call trace:
__free_pages_ok
__free_pages
__free_pages_bootmem
free_all_bootmem_core
free_all_bootmem
mem_init
start_kernel
tlb_fixup_done

Can it be helpful?

I tried to connect console cable to it, but nothing was there. I found
I should disconnect keyb and vga to able to see it, I will try it
later, perhaps not today.

>
> Please also double check that you patched the kernel with my
> fix correctly.  I used your exact config, on the exact same
> kind of system, reproducing the exact same hang, and it goes
> away with my fix.
>
