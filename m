Return-Path: <linux-kernel-owner+w=401wt.eu-S934027AbZKXVTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbZKXVTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933487AbZKXVT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:19:29 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60413 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933961AbZKXVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:19:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jM0T6l/rG522ftroHQyZgRYJnpUgVrFz2uVBAKz7wTi7pft5RZYGebGNDkrZhrtovC
         0FJwdAgr1ECZm70ZBcIZm3DEPmYI3rkCLF2/GFKszQ/kQZ2rfWLeyjC9k+8Ly6Sny9Bj
         u2rW39IC704iONHMyWfD/UBk8oCbKcQX426fg=
MIME-Version: 1.0
In-Reply-To: <1259097150.4531.1822.camel@laptop>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <20091124170032.GC6831@linux.vnet.ibm.com>
	 <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>
	 <1259090615.17871.696.camel@calx> <1259095580.4531.1788.camel@laptop>
	 <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop>
	 <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com>
	 <1259097150.4531.1822.camel@laptop>
Date: Tue, 24 Nov 2009 23:19:33 +0200
X-Google-Sender-Auth: 787d35825ac99d49
Message-ID: <84144f020911241319g24dbfbd0j9a27698539404e36@mail.gmail.com>
Subject: Re: lockdep complaints in slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       paulmck@linux.vnet.ibm.com, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-11-24 at 13:03 -0800, David Rientjes wrote:
>> On Tue, 24 Nov 2009, Peter Zijlstra wrote:
>>
>> > Merge SLQB and rm mm/sl[ua]b.c include/linux/sl[ua]b.h for .33-rc1
>> >
>>
>> slqb still has a 5-10% performance regression compared to slab for
>> benchmarks such as netperf TCP_RR on machines with high cpu counts,
>> forcing that type of regression isn't acceptable.
>
> Having _4_ slab allocators is equally unacceptable.

The whole idea behind merging SLQB is to see if it can replace SLAB.
If it can't do that in few kernel releases, we're pulling it out. It's
as simple as that.

And if SLQB can replace SLAB, then we start to talk about replacing SLUB too...

                        Pekka
