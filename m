Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYHLOFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYHLOFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYHLOFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:05:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55299 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbYHLOFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:05:38 -0400
Date: Tue, 12 Aug 2008 17:03:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, fritz@isdn4linux.de, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
Message-ID: <20080812140352.GH13910@cs181140183.pp.htv.fi>
References: <489DD669.2090207@keyaccess.nl> <20080809215020.1bb602e7@lxorguk.ukuu.org.uk> <20080811164814.db41c20b.akpm@linux-foundation.org> <48A11952.6090203@keyaccess.nl> <20080811223043.9ad55c51.akpm@linux-foundation.org> <20080812130823.GD13910@cs181140183.pp.htv.fi> <48A18F7B.6040809@keyaccess.nl> <20080812134337.GG13910@cs181140183.pp.htv.fi> <48A195DD.5050602@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48A195DD.5050602@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:53:33PM +0200, Rene Herman wrote:
> On 12-08-08 15:43, Adrian Bunk wrote:
>
>>> Currently, we have a tristate that turns into a y/n bool if !MODULES. 
>>>  What would be real nice here is a tristate that turns into a m/n 
>>> bool if  !RANDOM, where allyesconfig and randconfig would pre-select 
>>> RANDOM.
>>
>> allyesconfig is not random.
>
> Oh, how very, very important. s/RANDOM/!SPECIFIC/ then (and I meant "if  
> RANDOM" ofcourse).
>
> The point is just that such a tristate would be a one-stop mark for  
> drivers/options that you want to be  specifically selected for builtin  
> use since they're not necessarily expected to boot on general PCs.

The part of what you want that is AFAIK not possible with the current 
kconfig is the "allyesconfig and randconfig would pre-select".

The actual dependencies on such an option could trivially be expressed 
the way you want it.

But I'm trying to make the kconfig dependencies more robust by making 
them less complex, and making them more complex for this developer-only
use case is nonsense.

Even more considering that the developer who gave the initial list of 
variables is the same who always spreads FUD about kconfig when the 
complex dependencies break...

> Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

