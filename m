Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXHVUFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXHVUFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbXHVUE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:04:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63541 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760093AbXHVUE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:04:57 -0400
Message-ID: <46CC9696.1070107@oracle.com>
Date: Wed, 22 Aug 2007 13:03:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822110348.8fd6a937.randy.dunlap@oracle.com> <20070822113211.9ac85162.akpm@linux-foundation.org> <20070822193857.GC8058@bingen.suse.de> <20070822121731.011cd263.randy.dunlap@oracle.com> <20070822205311.GH8058@bingen.suse.de>
In-Reply-To: <20070822205311.GH8058@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Aug 22, 2007 at 12:17:31PM -0700, Randy Dunlap wrote:
>>> Why does that compiler not know __builtin_abs?
>> I dunno:
>>
>>> gcc --version
>> gcc (GCC) 4.1.0 (SUSE Linux)
> 
> Hmm I use the same compiler from SUSE10.2 and it works for me (with both
> mm and only my tree applied) 
> 
> Ok mm fails with some errors in the wireless drivers but with 
> wireless disabled it compiles.
> 
> When you compile a simple test program like
> 
> main() { printf("%lu\n", __builtin_labs(-1)); }
> 
> does it work?

Yes, that works.

>>>> One wonders why x86_64-mm-unwinder.patch has an open-coded call to
>>>> __builtin_labs(), when include/linux/kernel.h:abs() should do a fine job.
> 
> Andrew, I actually checked that and the abs() there is just abs()
> not a labs(). So it wouldn't work on 64bit platform.
> 
> We could opencode it of course, but __builtin_labs should be really 
> there.
> 
> -Andi


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
