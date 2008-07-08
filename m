Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYGHVwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYGHVwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYGHVwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:52:13 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:12175 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYGHVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=btbZnk+0QGB9Ho+eQPNjscTwh54eI/P3WnJHi2et9UyVtHBsgG2yR5pBveenJfXBrD
         P77oSht/9ZKIpfsZjP3s+nBAMhsrlI4HU8KyL8ms2RGoyEnQaaCMY5NHkrayoOPDvd2M
         SKibCsUtD1Pn5cVgEdcDGp7+Yi+ybuO9tC7oA=
Message-ID: <19f34abd0807081452l587c8388g1cdb2d3c01e0e13a@mail.gmail.com>
Date: Tue, 8 Jul 2008 23:52:10 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4873DD99.7050001@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
	 <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com>
	 <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>
	 <4873AC5C.1040705@sgi.com>
	 <19f34abd0807081122p20c73cd9p7129d297ac36a3ad@mail.gmail.com>
	 <4873D33B.4040300@sgi.com>
	 <19f34abd0807081421j67771dbclfae1fcfaa9ad4bcd@mail.gmail.com>
	 <4873DD99.7050001@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 11:35 PM, Mike Travis <travis@sgi.com> wrote:
> Subject: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
>
>  * Strengthen the return type for the _node_to_cpumask_ptr to be
>    a const pointer.  This adds compiler checking to insure that
>    node_to_cpumask_map[] is not changed inadvertently.
>
> Applies to tip/master with the following patch applied:
>
>        "[PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3"
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---

I can successfully cross-compile the asm-generic changes with a NUMA=y
config on ia64 without error or warning. So I guess, at long last, you
may put, FWIW:

    Acked-by: Vegard Nossum <vegard.nossum@gmail.com>

Sorry for causing much trouble...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
