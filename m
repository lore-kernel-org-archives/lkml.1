Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbXCaIPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbXCaIPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbXCaIPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:15:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48282 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXCaIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:15:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
	<20070331071220.GA26910@aitel.hist.no>
	<20070331005303.354411f0.akpm@linux-foundation.org>
Date: Sat, 31 Mar 2007 02:14:18 -0600
In-Reply-To: <20070331005303.354411f0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 31 Mar 2007 00:53:03 -0700")
Message-ID: <m1mz1thlt1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 31 Mar 2007 09:12:20 +0200 Helge Hafting <helgehaf@aitel.hist.no> wrote:
>
>> A new error for me:
>> 
>> loading 2.6.21rc5mm3
>> Bios data check successful
>> Destination address not 2M aligned
>>  -- System halted
>> 
>> 
>> This is using the same lilo that loads 2.6.18rc5mm1 fine.
>> x86-64
>> 
>
> That's new.  Does changing the value of CONFIG_RELOCATABLE change anything?

I will have to dig a little deeper but this certainly sounds like the
x86_64 relocatable kernel patches.  I believe the check is in 
arch/x86_64/boot/compressed/misc.c

I think the interesting .config variable is going to be
CONFIG_PHYSICAL_START.

I suspect that isn't going to be 2M aligned, like the kernel requires
for best performance.

> Please send the .config.

Please.

Eric

