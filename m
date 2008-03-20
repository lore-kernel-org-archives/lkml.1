Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYCTO35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYCTO35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbYCTO3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:29:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbYCTO3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:29:32 -0400
Message-ID: <47E273D0.40402@redhat.com>
Date: Thu, 20 Mar 2008 11:25:20 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
Subject: Re: [PATCH 58/79] [PATCH] include mach_apic.h in smpboot_64.c and
 smpboot.c
References: <12059475744092-git-send-email-gcosta@redhat.com>	 <1205947719906-git-send-email-gcosta@redhat.com>	 <12059477234148-git-send-email-gcosta@redhat.com>	 <12059477273855-git-send-email-gcosta@redhat.com>	 <1205947732309-git-send-email-gcosta@redhat.com>	 <12059477371787-git-send-email-gcosta@redhat.com>	 <12059477421707-git-send-email-gcosta@redhat.com>	 <12059477472416-git-send-email-gcosta@redhat.com>	 <12059478321396-git-send-email-gcosta@redhat.com>	 <12059478362371-git-send-email-gcosta@redhat.com> <86802c440803192356l6ff7e8dg9cfbfd3bc045dcac@mail.gmail.com>
In-Reply-To: <86802c440803192356l6ff7e8dg9cfbfd3bc045dcac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Mar 19, 2008 at 10:25 AM, Glauber de Oliveira Costa
> <gcosta@redhat.com> wrote:
>> From: Glauber Costa <gcosta@redhat.com>
>>
>>  After the inclusion, a lot of files needs fixing for conflicts,
>>  some of them in the headers themselves, to accomodate for both
>>  i386 and x86_64 versions.
>>
>>  Signed-off-by: Glauber Costa <gcosta@redhat.com>
>>  ---
>>   arch/x86/kernel/acpi/boot.c                 |    2 ++
>>   arch/x86/kernel/mpparse_64.c                |    2 ++
>>   arch/x86/kernel/smpboot.c                   |    2 ++
>>   arch/x86/kernel/smpboot_64.c                |    1 +
>>   arch/x86/vdso/Makefile                      |    2 +-
>>   include/asm-x86/apic.h                      |    1 -
>>   include/asm-x86/apicdef.h                   |    6 ------
>>   include/asm-x86/mach-default/mach_apic.h    |   11 +++++++++++
>>   include/asm-x86/mach-default/mach_apicdef.h |    5 +++++
>>   include/asm-x86/smp_64.h                    |    9 +--------
>>   10 files changed, 25 insertions(+), 16 deletions(-)
> 
> please don't.
> 
> before this patch
> include/asm-x86/mach_apic.h is only for x86_64 only
> include/asm-x86/mach-default/mach_apic.h is for i386 only.
> 
> and both have __ASM_MACH_APIC_H defined.
> 
> may need another name?
> 
> YH
Another name is possible, but I'd prefer to get rid of the 
asm-x86/mach_apic.h. The goal here is to have things integrated, so 
unless really necessary, this is prefered.

Is this related to your problem anyhow? (just in curiosity)

