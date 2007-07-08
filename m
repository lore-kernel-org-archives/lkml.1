Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbXGHFLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbXGHFLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 01:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXGHFLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 01:11:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:61265 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXGHFLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 01:11:05 -0400
Message-ID: <469071AB.4050009@windriver.com>
Date: Sun, 08 Jul 2007 00:10:03 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: 2.6.22-rc6-mm1: git-kgdb breaks sh compilation
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070707080358.GF3492@stusta.de>
In-Reply-To: <20070707080358.GF3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2007 05:10:04.0433 (UTC) FILETIME=[3E743010:01C7C11E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>   
>> ...
>> Changes since 2.6.22-rc4-mm2:
>> ...
>>  git-kgdb.patch
>> ...
>>  git trees
>> ...
>>     
>
> This tree adds to include/asm-sh/system.h code that already exists in 
> the same file a few lines above resulting in compile errors.
>
> Please remove the include/asm-sh/system.h part from the git tree.
>
> cu
> Adrian
>
>   

Adrian,

This is fixed in the for_mm branch of the kgdb git repository so it will 
be fixed on next pull into the -mm tree.

I also cleaned up the sh-lite.patch to comply with checkpatch.pl

Thanks,
Jason.
