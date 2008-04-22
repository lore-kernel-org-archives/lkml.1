Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYDVEdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYDVEdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYDVEdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:33:00 -0400
Received: from stinky.trash.net ([213.144.137.162]:58616 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYDVEdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:33:00 -0400
Message-ID: <480D6A76.3080401@trash.net>
Date: Tue, 22 Apr 2008 06:32:54 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: kgdb build error
References: <480C78AF.1060903@trash.net> <20080421191838.GB3104@elte.hu>
In-Reply-To: <20080421191838.GB3104@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Patrick McHardy <kaber@trash.net> wrote:
> 
>> I get this build error with current -git on x86_64 (config attached):
>>
>>   CC      arch/x86/kernel/kgdb.o
>> arch/x86/kernel/kgdb.c:52:28: error: asm/mach_apic.h: No such file or 
>> directory
>> arch/x86/kernel/kgdb.c: In function 'kgdb_roundup_cpus':
>> arch/x86/kernel/kgdb.c:337: error: implicit declaration of function 
>> 'send_IPI_allbutself'
> 
> yep, this should fix it:
> 
>   http://lkml.org/lkml/2008/4/19/35
> 
> (also attached below, or available in x86.git.)


Thanks, it compiles cleanly with this patch.
