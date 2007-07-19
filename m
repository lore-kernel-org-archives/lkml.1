Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbXGSWqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbXGSWqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXGSWpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:45:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:60536 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbXGSWpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:45:52 -0400
In-Reply-To: <20070719143020.5e0b7474.akpm@linux-foundation.org>
References: <20070714012033.GC31649@Krystal> <20070718223034.7388e59f.akpm@linux-foundation.org> <D9805F9D-04B0-4422-81F1-958B15482A93@kernel.crashing.org> <20070719131348.170443bb.akpm@linux-foundation.org> <E7820A72-36A3-4B4D-A497-974409D3EBDE@kernel.crashing.org> <20070719143020.5e0b7474.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DF1DBB27-33A8-43E9-8420-DED6ACBA2364@kernel.crashing.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Powerpc - Include pagemap.h in asm/powerpc/tlb.h
Date: Thu, 19 Jul 2007 17:46:15 -0500
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 19, 2007, at 4:30 PM, Andrew Morton wrote:

> On Thu, 19 Jul 2007 16:04:38 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>>>> Andrew,
>>>>
>>>> Are you sending this to linus directly or should this go via  
>>>> paul and
>>>> me?
>>>>
>>>
>>> I queued it up for Paul.  I can send it over to Linus today if we
>>> have a
>>> reason for that.  It's just that I dont understand the patch: does
>>> it fix
>>> -mm-only breakage?  Does it fix something which already got fixed,
>>> or what?
>>
>> I'm seeing the same breakage in my tree.
>
> Oh, OK.  Let's just merge it.

Hmm, depending on the config it goes away.

Lets hold off on this for a little while so understand exactly what's  
going on.

>>> One might think "gee, it's trivial, just slam it in", but these  
>>> nested
>>> includes are often not-trivial and something else can explode as a
>>> result.
>>
>> I'll do a git-bisect and see if I can find the patch that causes this
>> breakage so we know what's going on.
>
> eh, don't bother.

I think I'll poke around a little since it clearly has some config  
dependancy.

- k

