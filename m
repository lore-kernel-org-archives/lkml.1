Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYG2XrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYG2XrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYG2XrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:47:10 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:49440 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbYG2XrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:47:09 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1: fails to compile
Date: Wed, 30 Jul 2008 09:46:58 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <ruav84p0ceqcbl07oeb375k95n7heg7unp@4ax.com>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <g54v84t6rgqplte4tvjrlh4r8g3m6n8kms@4ax.com> <20080729224049.GA7325@slug>
In-Reply-To: <20080729224049.GA7325@slug>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 00:40:49 +0200, Frederik Deweerdt <deweerdt@free.fr> wrote:

>Hello Grant,
>On Wed, Jul 30, 2008 at 08:03:42AM +1000, Grant Coady wrote:
>> On Mon, 28 Jul 2008 20:23:21 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> 
>> >
>> >It's two weeks (and one day), and the merge window is over.
>> >
>> >Finally. I don't know why, but this one really did feel pretty dang busy. 
>> >And the size of the -rc1 patch bears that out - at 12MB, it's about 50% 
>> >bigger than 26-rc1 (but not that much bigger than 24/25-rc1, so it's not 
>> >like it's anything unheard of).
>> 
>> Couple machines failed to compile with same error in different place:
>> 
>>   CC      arch/x86/kernel/acpi/cstate.o
>> arch/x86/kernel/acpi/cstate.c: In function `acpi_processor_ffh_cstate_probe':
>> arch/x86/kernel/acpi/cstate.c:94: error: invalid lvalue in unary `&'
>> make[2]: *** [arch/x86/kernel/acpi/cstate.o] Error 1
>> make[1]: *** [arch/x86/kernel/acpi] Error 2
>> make: *** [arch/x86/kernel] Error 2
>> grant@peetoo:~/linux/linux-2.6.27-rc1a$
>> 
>This issue has been reported, this is due to your old compiler.
>Fix here:
>http://lkml.org/lkml/2008/7/29/48

Thanks, that does the trick :)

Grant.
>
>Regards,
>Frederik

