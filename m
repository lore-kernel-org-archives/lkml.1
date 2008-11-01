Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbYKAMvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbYKAMvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 08:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYKAMvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 08:51:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:57466 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYKAMvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 08:51:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gJby7UxRM9xDd3JOdnvhkrPJgvtSr3TaRxxe9iLEsn53GXhkVwkklp7MM/dmGrCxa0
         l4pQmLF1LcWCL9WaWU+sirKQ5uXgn4pQtUFwPgHqQFZ8FVluVXZNn4UtDDKdOCq2PT4l
         4jbsCjQQ9ceRFGIEidUS0tb1CETEMsyzOsb3o=
Message-ID: <4d8e3fd30811010551s4163d81bi96dcd98fb3440b72@mail.gmail.com>
Date: Sat, 1 Nov 2008 13:51:39 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Cc: "Mike Galbraith" <efault@gmx.de>, "David Miller" <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, jkosina@suse.cz, akpm@linux-foundation.org,
       rjw@sisk.pl, s0mbre@tservice.net.ru, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20081029095037.GA7973@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027113306.5b1d5898@lxorguk.ukuu.org.uk>
	 <20081027183312.GD11494@elte.hu> <20081027193933.GB2590@ioremap.net>
	 <20081027.124848.163119274.davem@davemloft.net>
	 <1225189462.4903.238.camel@marge.simson.net>
	 <20081028103741.GA22319@elte.hu> <20081029091405.GA3780@ioremap.net>
	 <20081029095037.GA7973@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 10:50 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Wed, Oct 29, 2008 at 12:14:05PM +0300, Evgeniy Polyakov (zbr@ioremap.net) wrote:
>> vanilla 27    : 347.222
>> no TSO/GSO    : 357.331
>> no hrticks    : 382.983
>> no balance    : 389.802
>> 4403b4 commit : 361.184
>> dirty_ratio-50        : 361.086
>> no-sched-tweaks       : 361.367
>>
>> So, probably, if we revert -tip merge to vanilla .27, add nohrtick patch
>> and nobalance tweak _only_, and apply naive TSO patch we could bring
>> system to 400 MB/s. Note, that .22 has 479.82 and .23 454.36 MB/s.
>
> And now I have to admit that the very last -top merge did noticebly
> improve the situation upto 391.331 MB/s (189 in domains, with tso/gso
> off and naive tcp_tso_should_defer() hange).
>
> So we are now essentially at the level of 24-25 trees in my tests.

That's good and make think whether it would be a good idea to add some
performance number in each pull request that affect the core part of
the kernel.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
