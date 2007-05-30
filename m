Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbXE3Vxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbXE3Vxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758517AbXE3VxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:53:18 -0400
Received: from raven.upol.cz ([158.194.120.4]:54436 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972AbXE3VxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:53:17 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 17:53:15 EDT
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Milind Arun Choudhary" <milindchoudhary@gmail.com>,
       <kernel-janitors@lists.osdl.org>, <linux-ia64@vger.kernel.org>,
       <discuss@x86-64.org>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <ak@suse.de>
Subject: Re: [KJ][PATCH 02/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
In-Reply-To: <617E1C2C70743745A92448908E030B2A015B4E12@scsmsx411.amr.corp.intel.com>
References: <20070413043140.GA9431@arun.site> <617E1C2C70743745A92448908E030B2A015B4E12@scsmsx411.amr.corp.intel.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed + slrn (x86_64-pc-linux-glibc-debian)
Date: Wed, 30 May 2007 23:57:49 +0200
Message-Id: <E1HtWAv-00028d-9l@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: "Luck, Tony"
* Date: Fri, 13 Apr 2007 09:45:49 -0700

>> So as ALIGN macro does the same work as ROUNDUP,
>
> Although it is mathematically the same operation, the
> semantic associations of the name are important too.
[]
> Maybe this is because I started out in mathematics before
> discovering that computers were so much fun, or maybe it
> is a British-English bias ... I can't tell, but it makes
> sense to me to use ROUNDUP in some places, and ALIGN in
> others.

I agree. I came from neither one (still coming); first look and vague
semantics of ALIGN macro, English confusion, a bit of laziness, led me to
stupid messages about aligning, Linus being so kind to reply, a couple of
months ago. Anyway i did that after some patching and re-patching that
macro by gurus :).

> If ROUNDUP isn't available everywhere, then it should be. To
> avoid code duplication perhaps we should add:
>
>     #define ROUNDUP(size, len) ALIGN((size), (len))
>
> and delete the previous ROUNDUP definition?

And i would vote for "align" via "round".
____
