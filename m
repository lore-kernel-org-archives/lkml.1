Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093Ab0AEC0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0AEC0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0AEC0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:26:55 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:44595 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0AEC0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:26:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TIhsKSMjnneNn7SoqY4bHnRU6e53+tAJSHhOs8l2YK98IVECbtSqg8BJsAL/zRo3Ad
         nwhnq73i/qDLj3WeGmRDUYhfFXLmoFYrTnCzL9r0DdrWHvs/EzGuzhd2vCDSNKSFploN
         PdFmvVWN9SLUceHKlpqcwtEyLfc4jCOBcMgOw=
MIME-Version: 1.0
In-Reply-To: <20100104182429.833180340@chello.nl>
References: <20100104182429.833180340@chello.nl>
Date: Tue, 5 Jan 2010 11:26:52 +0900
Message-ID: <28c262361001041826h6a63af37s4d8f88208a387ead@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] Speculative pagefault -v3
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter.

On Tue, Jan 5, 2010 at 3:24 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Patch series implementing speculative page faults for x86.
>
> Still needs lots of things sorted, like:
>
>  - call_srcu()
>  - ptl, irq and tlb-flush
>  - a 2nd VM_FAULT_LOCK? return code to distuinguish between
>    simple retry and must take mmap_sem semantics?
>
> Comments?
> --
>
>

I looked over this patch series.
This series are most neat in things I have ever seen.
If we solve call_srcu problem, it would be good.

I will help you test this series in my machine to work well.

-- 
Kind regards,
Minchan Kim
