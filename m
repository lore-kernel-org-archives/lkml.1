Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYEDITc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYEDITc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYEDITT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:19:19 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:56421 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbYEDITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:19:18 -0400
Message-ID: <481D71D3.7060703@seznam.cz>
Date: Sun, 04 May 2008 10:20:35 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: paulus@samba.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and
 of_platform.c
References: <monstr@seznam.cz> <1209824532-7939-1-git-send-email-monstr@seznam.cz> <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu> <200805032304.58709.arnd@arndb.de>
In-Reply-To: <200805032304.58709.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

this is question to powerpc guys not to me. I haven't tried to compiled but I
think dcr.h is important header for powerpc.
I only fixed problem for Microblaze because we don't have these headers.

M

>>  
>>  #include <asm/errno.h>
>> +
>> +#ifdef CONFIG_PPC_PSERIES
>>  #include <asm/dcr.h>
>> +#endif
>>  
> 
> The patch looks basically good, but we normally try to not have an #include
> inside of #ifdef. If the file builds without this #include, maybe you should
> better leave it out entirely? Same for the ppc-pci.h in the other file.
> 
> 	Arnd <><
> 

