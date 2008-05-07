Return-Path: <linux-kernel-owner+w=401wt.eu-S1765298AbYEGSju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765298AbYEGSju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYEGSjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:39:37 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:59855 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755952AbYEGSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:39:35 -0400
Message-ID: <4821F794.10003@seznam.cz>
Date: Wed, 07 May 2008 20:40:20 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       John Linn <linnj@xilinx.com>, john.williams@petalogix.com,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open firmware
 files
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu> <20080507160432.93FC11750046@mail35-dub.bigfish.com>
In-Reply-To: <20080507160432.93FC11750046@mail35-dub.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

you are right. Microblaze don't need CONFIG_PPC_something but
I keep this in files because it will be easier to move this to better place.
I wanted to sort what Microblaze don't use.

I need to talk with people from sparc and powerpc what we can move and where.
I see the best way to push these files to microblaze/kernel/ and then sychronize
them with one patch - all archs together.

M

>> +#ifdef CONFIG_PPC_PSERIES
>> +#include <asm/rtas.h>
>> +#include <asm/kdump.h>
>> +#include <asm/smp.h>
>> +#include <asm/iommu.h>
>> +#include <asm/btext.h>
>> +#include <asm/machdep.h>
>> +#include <asm/pSeries_reconfig.h>
>> +#include <asm/phyp_dump.h>
>> +#include <asm/kexec.h>
>> +#endif
> 
> I don't think we need CONFIG_PPC_PSERIES (multiple times)
> 
>> +#ifdef CONFIG_PPC64
>> +int __initdata iommu_is_off;
>> +int __initdata iommu_force_on;
>> +unsigned long tce_alloc_start, tce_alloc_end;
>> +#endif
> 
> or PPC64 (multiple times
> 
>> +#ifdef CONFIG_PPC32
> 
> or PPC32
> 
> Steve
> 
> 
> 
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 
