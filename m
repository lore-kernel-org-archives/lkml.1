Return-Path: <linux-kernel-owner+w=401wt.eu-S1764646AbZEARVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764646AbZEARVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZEARU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:20:59 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:28640 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZEARU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:20:57 -0400
Message-ID: <49FB2FCB.5010303@oracle.com>
Date: Fri, 01 May 2009 10:22:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Christopher Sylvain <chris.sylvain@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: additional info for kernel-parameters.txt
References: <c4cb03b00904231631k49902d45o9ba6bad7e4b21094@mail.gmail.com> <alpine.LSU.2.00.0905011909440.7409@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0905011909440.7409@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49FB2F73.0145:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> [Cc: linux-kernel]
> 
> On Friday 2009-04-24 01:31, Christopher Sylvain wrote:
> 
>> a while ago you invited patches to kernel-parameters.txt when someone said
>> they were
>> unhappy with a reference to a source file instead of listing the actual
>> parameters.
> 
> [1] possibly http://lkml.org/lkml/2006/12/18/185
> 
> 
>> instead of a patch, how about simply adding:
>> -----
>>
>> (We allow underscores for compatibility with the modules code)
>> apm=on/off enable/disable APM
>> [no-]allow[-_]ints allow interrupts during BIOS calls
>> [no-]broken[-_]psr BIOS has a broken GetPowerStatus call
>> [no-]realmode[-_]power[-_]off switch to real mode before powering off
>> [no-]debug log some debugging messages
>> [no-]power[-_]off power off on shutdown
>> [no-]smp Use apm even on an SMP box
>> bounce[-_]interval=<n> number of ticks to ignore suspend bounces
>> idle[-_]threshold=<n> System idle percentage above which to make APM BIOS
>> idle calls. Set it to 100 to disable.
>> idle[-_]period=<n> Period (in 1/100s of a second) over which the idle
>> percentage is calculated.
>>
>> see /linux/arch/x86/kernel/apm_32.c for some additional information
> 
> Saying "we allow underscores" is enough, I would not clutter the 
> textfile with [-_].

Agreed.  This is what kernel/params.c says:

/* Hyphens and underscores equivalent in parameter names. */


>> -----
>>
>> to the entry for [APM] ?


-- 
~Randy
