Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbXDWVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbXDWVx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbXDWVx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:53:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:49027 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbXDWVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CJL+udBjnQ2NEHGKSSGTDfhHWzpm6kdQqaUbMgTRQzj/cF6BVtKXYUcoRGfvmZLZdMPj8y3Nkr5Ksfxvjk/Ib6O8SZV354PjFGxoxUT184EPAml7wJVu5VRWmuGxhr/uh07giu4i/gDK4rkTZWROcP1aO6OHpE3H1sNJVtQeYJU=
Message-ID: <3d8471ca0704231453lc994abk33fa487c74c74cd3@mail.gmail.com>
Date: Mon, 23 Apr 2007 23:53:25 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Juliusz Chroboczek" <jch@pps.jussieu.fr>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Bill Davidsen" <davidsen@tmr.com>, "Willy Tarreau" <w@1wt.eu>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <20070423203317.GA26668@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu> <20070421160008.GA28783@elte.hu>
	 <200704220959.34978.kernel@kolivas.org>
	 <87647oblx5.fsf@pps.jussieu.fr>
	 <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
	 <20070423013429.GB25162@wotan.suse.de>
	 <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
	 <20070423191143.GA16849@elte.hu>
	 <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
	 <20070423203317.GA26668@elte.hu>
X-Google-Sender-Auth: ae249e6d877c0322
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/23, Ingo Molnar <mingo@elte.hu>:
>                 p->wait_runtime >>= 1;
>                 p_to->wait_runtime += p->wait_runtime;

I have no problem with clients giving some credit to X,
I am more concerned with X giving half of its credit to
a single client, a quarter of its credit to another client, etc...

For example, a client could setup a periodical wake up
from X, and then periodically getting some credit for free.
Would that be possible?

Thanks.

-- 
Guillaume
