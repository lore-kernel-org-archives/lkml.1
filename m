Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CJKU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:20:56 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41611 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0CJKUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:20:52 -0500
Message-ID: <4B977282.40505@cs.helsinki.fi>
Date: Wed, 10 Mar 2010 12:20:50 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "=?UTF-8?B?QW3DqXJpY28gV2FuZw==?=" <xiyou.wangcong@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       mingo@elte.hu, akpm@linux-foundation.org, roland@redhat.com,
       peterz@infradead.org
Subject: Re: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
References: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
In-Reply-To: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang kirjoitti:
> Hello, mm experts,
> 
> I triggered an mm bug today, the full backtrace is here:
> 
> http://pastebin.ca/1831436
> 
> I am using yesterday's Linus tree.
> 
> It's not easy to reproduce this, I got this very randomly.
> 
> Some related config's are:
> 
> CONFIG_SLAB=y
> CONFIG_SLABINFO=y
> # CONFIG_DEBUG_SLAB is not set
> 
> Please let me know if you need more info.

Looks like regular SLAB corruption bug to me. Can you trigget it with SLUB?

Anyway, it seems very unlikely that it's caused by the SLAB changes in 
-rc1 so I'm CC'ing scheduler and fs folks in case the oops rings a bell.

			Pekka
