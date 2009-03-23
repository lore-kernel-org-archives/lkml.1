Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbZCWTIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbZCWTIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbZCWTI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:08:29 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39806 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618AbZCWTI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TQ1QwHd61JWa/JNRtv3VqiYWmL2AvDWeTMlAyhTeqN+P/qJy8rehR4GgOVskaS3WTe
         fC+UX3/9q0ihb4fVW+HuTIgHm1cvS32LX4pi51MK8Fw0/koix7KmP0ZdckXbbnv4Mj/t
         EAl3lx/vbgzF7/vUDRylrhX1tboLsJ9hl5Kms=
Message-ID: <49C7DE25.4030706@googlemail.com>
Date: Mon, 23 Mar 2009 20:08:21 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com,
       peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: Re: [patch] fix ptrace slowness
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu> <20090323151954.GC21267@elte.hu> <E1Llmpk-0001A3-2E@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Llmpk-0001A3-2E@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Miklos Szeredi wrote:
> On Mon, 23 Mar 2009, Ingo Molnar wrote:
> 
>>* Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>
>>>This one incorporates comments from Oleg and Ingo.  Please apply 
>>>to 2.6.29 and 2.6.2[78]-stable trees.
>>
>>The fix first needs to go upstream. There's an alternative patch 
>>below. Would you mind to give it a test? Chances are that it will 
>>make UML even faster than your fix.
> 
> 
> Just the opposite.  With my patch a UML image boots in 17 seconnds,
> with your patch it boots in 33 seconds.  Without either patch it boots
> in about 5 minutes.

My strace test case runs 60% faster with this patch (compared to Ingo's).

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
