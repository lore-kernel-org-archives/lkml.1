Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYFYRq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYFYRq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYFYRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:46:51 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:39261 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYFYRqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DkeZH4YgJ0EAgEOCOphMn0qAp3yYWO0v68kaf2NisOASwqd+PwQvzGtLFCs1kwtjvR
         wTFMoJkxM76SpFtC8KR0WcOS+lXTSeyfCH1ye5i0o+x0fnl21cWjp6RvE0n1sfCwd3q3
         F+fo661I7OqniW8jCXH6+pSVLzLEBIP5HcLTc=
Message-ID: <86802c440806251046g4d5145a2y72aa2b6cd83a98f7@mail.gmail.com>
Date: Wed, 25 Jun 2008 10:46:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <486282A8.5020306@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806242213.15310.yhlu.kernel@gmail.com>
	 <200806242214.09503.yhlu.kernel@gmail.com>
	 <200806250114.09858.yhlu.kernel@gmail.com>
	 <20080625153614.GB18796@elte.hu>
	 <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>
	 <20080625164300.GC6040@elte.hu>
	 <86802c440806251028sb9a98e3ncbae3b3130c02fa6@mail.gmail.com>
	 <486282A8.5020306@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 10:38 AM, Mike Travis <travis@sgi.com> wrote:
> Yinghai Lu wrote:
>> On Wed, Jun 25, 2008 at 9:43 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>
>>>>>>  include/asm-x86/setup.h    |    2
>>>>>>  5 files changed, 670 insertions(+), 934 deletions(-)
>>>>> very nice!
>>>>>
>>>>> could we please split this up into several, gradual steps that bring
>>>>> setup_32.c and setup_64.c to exactly the same content - where the final
>>>>> patch just renames arch/x86/kernel/setup_32.c to arch/x86/kernel/setup.c
>>>>> and deletes arch/x86/kernel/setup_64.c ?
>>>> OK, someone (Mike Triavis) already stole setup.c for X86_NUMA.
>>>>
>>>> You need to change that setup.c to other name. or split it away...
>>> hm, that change was supposed to be the seed of a unification. So if it
>>> actually hinders you, feel free to move it to a different file.
>>> Obviously it is setup_32.c and setup_64.c that should be unified into
>>> setup.c.
>>
>> ok, I will change that setup_percpu.c
>>
>> YH
>
> One thing I was trying to do was to merge more stuff from setup_32/64 into
> setup.c.  Unfortunately, there was some test failures on i386 that I did not
> have time to debug.  But the file existed before my time. ;-)
>
> Why does the current setup.c need to be renamed and not simply add the merged
> changes into it?

Ingo want make setup_32.c have everything (in 10 patches), and then
rename setup_32.c to setup.c and delete setup_64.c

will move numa related to setup_numa.c or numa.c

YH
