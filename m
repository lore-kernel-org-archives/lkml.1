Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbYBBKVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbYBBKVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765989AbYBBKVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:21:30 -0500
Received: from gw.goop.org ([64.81.55.164]:56905 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYBBKV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:21:29 -0500
Message-ID: <47A443FE.6040900@goop.org>
Date: Sat, 02 Feb 2008 02:20:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: move pud/pgd functions into common	asm/pgalloc.h
References: <patchbomb.1201943112@localhost> <fe3ff49757e16a5b9290.1201943118@localhost> <20080202101356.GA19782@elte.hu>
In-Reply-To: <20080202101356.GA19782@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Common definitions for 4-level pagetable functions.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> ---
>>  arch/x86/mm/pgtable.c        |    7 ++++++
>>  include/asm-x86/pgalloc.h    |   46 ++++++++++++++++++++++++++++++++++++------
>>  include/asm-x86/pgalloc_32.h |   24 ---------------------
>>  include/asm-x86/pgalloc_64.h |   32 -----------------------------
>>  4 files changed, 47 insertions(+), 62 deletions(-)
>>     
>
> random-qa found an early bootup hang on 32-bit (config attached).
>   

The config you sent was 64-bit.

> i bisected it down to this patch of yours. It's a bit large so it's not 
> obvious what is happening. Could you please keep patches that do 
> functional changes smaller?

Will do, though this one is more or less pure code motion.  But I can 
make it actual pure code motion with a separate merge patch.

    J
