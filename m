Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYHBUDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYHBUDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbYHBUD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:03:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:52632 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYHBUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LpDUXJXaeFiGGbev2oJUENWMH2+40k324mts0PPj3bz9eoIbWYpVU7ldqf6FQPakbd
         ofgfdmJS4X3hEEd3UasgK/e4YjpgabuDBRjTSUL+UvBCP3VbHq4EByLy2klvhlsmlZbS
         tO+VOMZ+z1ygDYovd3xr2pNjH+mfjp2qU4yHc=
Message-ID: <6101e8c40808021303h10ecb2d7v70604740413c5df0@mail.gmail.com>
Date: Sat, 2 Aug 2008 22:03:25 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [RFC, 2.6.26.2-rc1] exec: remove some includes
Cc: "Hugh Dickins" <hugh@veritas.com>, stable@kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080802195622.GG615@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808022145.17161.oliver.pntr@gmail.com>
	 <20080802195622.GG615@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understood, I do not send patches with a character like this in the
future then, but I send it because of this in RFC

On 8/2/08, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Aug 02, 2008 at 09:45:17PM +0200, Oliver Pinter wrote:
>> >From ba92a43dbaee339cf5915ef766d3d3ffbaaf103c Mon Sep 17 00:00:00 2001
>> From: Hugh Dickins <hugh@veritas.com>
>> Date: Fri, 25 Jul 2008 01:45:43 -0700
>> Subject: [PATCH] exec: remove some includes
>>
>> [ Upstream commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c ]
>>
>> fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
>> mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.
>                                           ^^^^^^^
> Oliver, this patch apparently fixes nothing, and playing with includes
> always causes a risk of regression. Please ensure that only fixes for
> real problems are submitted to stable and check stable_kernel_rules.txt
> when in doubt.
>
> Willy
>
>


-- 
Thanks,
Oliver
