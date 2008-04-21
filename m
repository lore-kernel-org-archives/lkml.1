Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbYDURHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbYDURHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYDURG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:06:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:57926 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYDURG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XOdhewqpSkJ6k2ykLJrgBMvZISa2pia9I2TnIXmgoygbNYzHwy5ovQj0vdHCmGsJk4dUhEajWXyDk+LVVCvChNpJqY8ZI5AstDqkuBxj8BG3W0GFx4QA7d7hl0cSeTN9Of7eXZh5jtGIUZGRxRg7e0fd1P+mAGHIKsHf2N9ojos=
Message-ID: <480CC9A4.9090503@gmail.com>
Date: Mon, 21 Apr 2008 19:06:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2008 06:54 PM, Linus Torvalds wrote:
> Jiri - could you also confirm whether you are usign SLUB (which is not 
> necessarily at all indicative of a SLUB bug itself - it's just that SLAB 
> won't ever even merge different allocations of the same size into the same 
> buckets, so if it's a cross-slab corruption, you'd simply never see it 
> with SLAB).

Yeah, I'm using slub. Going to boot to slub_debug.

Thanks so far.

BTW. I haven't see this without suspend/resume cycle, do you, Rafael? It doesn't 
mean anything, since it needs longer time to trigger, but anyway, it might be a 
clue.
