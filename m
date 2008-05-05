Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYEEOXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYEEOXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYEEOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:23:34 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:65308 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753571AbYEEOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:23:33 -0400
Message-ID: <481F1891.4000400@seznam.cz>
Date: Mon, 05 May 2008 16:24:17 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 50/56] microblaze_v2: setup.h string.h thread_info.h
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>	 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>	 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>	 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>	 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>	 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>	 <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>	 <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>	 <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu>	 <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>	 <53e5b22838d017b7cf7f44c4bafe5f7e253732ce.1209897267.git.monstr@monstr.eu> <1209955168.5798.85.camel@localhost>
In-Reply-To: <1209955168.5798.85.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXED to r1.
M


>> +++ b/include/asm-microblaze/thread_info.h
>> @@ -0,0 +1,155 @@
>> +/*
>> + * include/asm-microblaze/thread_info.h
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License. See the file "COPYING" in the main directory of this archive
>> + * for more details.
>> + *
>> + * Copyright (C) 2006 Atmark Techno, Inc.
>> + */
>> +
>> +#ifndef _ASM_MICROBLAZE_THREAD_INFO_H
>> +#define _ASM_MICROBLAZE_THREAD_INFO_H
>> +
>> +#ifdef __KERNEL__
>> +
>> +/* we have 8k stack */
> 
> Is it worth trialling a 4K stack on MicroBlaze?
> 
> 
>> +struct cpu_context {
>> +	__u32	sp;
> 
> I'd be happier to see this called r1.  If mb-as doesn't accept "sp" as
> an alias for "r1", nor should we.
> 
> ...
> 
>> +	__u32	r30;
> 
> Is it worth a comment that r31 is absent because it's used as 'current'
> pointer, and -ffixed-r31 etc?
> 
> 
> 
> 
> 
