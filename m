Return-Path: <linux-kernel-owner+w=401wt.eu-S941606AbXHJTg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941606AbXHJTg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXHJTgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:36:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:23186 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbXHJTgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NiJMjj5lRhD4/UZ2+Pazjr3/NvQQihjZccLI2DRISkDzOBLnFYqqkmDGDXFBeIvjyJ5xuMsQts4LpbvV8Qgy6TXFLzKZVd7sfU8600UYYZzwnpLckYRJYhdbL+PsrmxGowtyjSlOMADBwk9sg3zUKuSXFOKduuyAIVpjQOXzx14=
Message-ID: <46BCBDB9.7070903@googlemail.com>
Date: Fri, 10 Aug 2007 21:34:17 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: arch/i386/kernel/setup.c - compile error (Re: 2.6.23-rc2-mm2)
References: <20070809224254.11f42716.akpm@linux-foundation.org>	<46BCA6A9.6000402@googlemail.com> <20070810114435.c6353b2a.akpm@linux-foundation.org>
In-Reply-To: <20070810114435.c6353b2a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Aug 2007 19:55:53 +0200
> Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>>>  git-newsetup.patch
>> ...
>>
>> arch/i386/kernel/setup.c: In function 'setup_arch':
>> arch/i386/kernel/setup.c:547: error: 'PARAM' undeclared (first use in this function)
>> arch/i386/kernel/setup.c:547: error: (Each undeclared identifier is reported only once
>> arch/i386/kernel/setup.c:547: error: for each function it appears in.)
>> make[1]: *** [arch/i386/kernel/setup.o] Error 1
>> make: *** [arch/i386/kernel] Error 2
>> make: *** Waiting for unfinished jobs....
>>  
>> ....
>>
>> Got it on a randconfig :
>>
>> http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-25
> 
> PARAM got removed, but include/asm-i386/mach-voyager/setup_arch.h still
> uses it.
> 
> 

Hmm voyager is somewhat broken ?

I reported 2 other problems already but no one seems to care.

http://marc.info/?l=linux-kernel&m=118505611205505&w=2 ( some warnings )
http://lkml.org/lkml/2007/7/23/167 ( compile error on !SMP )
