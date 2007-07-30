Return-Path: <linux-kernel-owner+w=401wt.eu-S934874AbXG3MQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874AbXG3MQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763548AbXG3MQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:16:17 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3164 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbXG3MQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:16:17 -0400
Message-ID: <46ADD68D.9080402@shadowen.org>
Date: Mon, 30 Jul 2007 13:16:13 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>,
       William Irwin <bill.irwin@oracle.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: mm/sparse.c compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070725040304.111550f4.akpm@linux-foundation.org>	<46AB77CA.1060705@googlemail.com> <20070728103048.24fb782d.akpm@linux-foundation.org>
In-Reply-To: <20070728103048.24fb782d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 28 Jul 2007 19:07:22 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Hi,
>>
>> next randconfig error ( http://194.231.229.228/MM/randconfig-auto-87.mm_sparse.error )
>>
>>
>> ...
>>
>> mm/sparse.c: In function 'sparse_init':
>> mm/sparse.c:482: error: implicit declaration of function 'sparse_early_usemap_alloc'
>> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
>> make[1]: *** [mm/sparse.o] Error 1
>> make: *** [mm] Error 2
>> make: *** Waiting for unfinished jobs....
>>
>> ...
>>
>>
>> guessing while this patch , but I am not really sure :
>>
>> fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
>>
> 
> That seems to have been fixed by one of the post-2.6.23-rc1-mm1 patches I merged,
> thanks.

I believe that this was fixed by a patch from Mel Gorman which I believe
merged into -mm as:

fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
	
-apw
