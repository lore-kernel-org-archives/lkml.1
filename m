Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZAUWXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZAUWXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZAUWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:23:19 -0500
Received: from gw.goop.org ([64.81.55.164]:35311 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZAUWXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:23:17 -0500
Message-ID: <4977A051.8050203@goop.org>
Date: Wed, 21 Jan 2009 14:23:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu> <20090121072718.GN24891@wotan.suse.de>
In-Reply-To: <20090121072718.GN24891@wotan.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Oh, _llc_ references/misses? Ouch.
>
> You have, what 32K L1I, 32K L1D, and 4MB L2? And even this microbenchmark
> is seeing increased L2 misses by nearly 3%. Hmm, I wonder where that is
> coming from? Instruction fetches?
>   

I assume so.  There should be no extra data accesses with 
CONFIG_PARAVIRT (hm, there's probably some extra stack/spill traffic, 
but I surely hope that's not falling out of cache).

    J
