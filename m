Return-Path: <linux-kernel-owner+w=401wt.eu-S1763371AbZAUApZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371AbZAUApZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbZAUApL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:45:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbZAUApK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:45:10 -0500
Message-ID: <49766FF0.9040401@cn.fujitsu.com>
Date: Wed, 21 Jan 2009 08:44:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
References: <49756F44.6040801@cn.fujitsu.com> <20090120075440.GA29426@elte.hu> <20090120081759.GA30394@elte.hu> <49758937.5070300@cn.fujitsu.com> <20090120082946.GC31473@elte.hu>
In-Reply-To: <20090120082946.GC31473@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> okay, a testsystem of mine just triggered this crash too.
>>>
>>> Li Zefan, Jaswinder, does the patch below fix it for you?
>>>
>> I'll test it, but I have to run for several hours to confirm it, since 
>> the bug is not easy to trigger. :)
> 
> yes. It triggered on an old 32-bit dual-socket HyperThreading system for 
> me and that is because HyperThreading is very good at triggering narrow 
> SMP races. (which this one certainly is)
> 
> (I'd expect Nehalem to trigger this TLB flushing race more easily too, 
> where HyperThreading made a comeback.)
> 

Nothing bad happaned in the last 16+ hours. :)

Tested-by: Li Zefan <lizf@cn.fujitsu.com>


