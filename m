Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbYF3SDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbYF3SDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763066AbYF3SDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:03:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763010AbYF3SDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:03:40 -0400
Date: Mon, 30 Jun 2008 20:03:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080630180304.GA23739@elte.hu>
References: <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48691E92.30809@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48691E92.30809@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> -tip auto-testing found pagetable corruption (CPA self-test failure):
>>
>> [   32.956015] CPA self-test:
>> [   32.958822]  4k 2048 large 508 gb 0 x 2556[ffff880000000000-ffff88003fe00000] miss 0
>> [   32.964000] CPA ffff88001d54e000: bad pte 1d4000e3
>> [   32.968000] CPA ffff88001d54e000: unexpected level 2
>> [   32.972000] CPA ffff880022c5d000: bad pte 22c000e3
>> [   32.976000] CPA ffff880022c5d000: unexpected level 2
>> [   32.980000] CPA ffff8800200ce000: bad pte 200000e3
>> [   32.984000] CPA ffff8800200ce000: unexpected level 2
>> [   32.988000] CPA ffff8800210f0000: bad pte 210000e3
>>
>> config and full log can be found at:
>>
>>  http://redhat.com/~mingo/misc/config-Mon_Jun_30_11_11_51_CEST_2008.bad
>>   
>
> This config doesn't have CONFIG_DEBUG_KERNEL enabled, let alone 
> CONFIG_CPA_DEBUG.  I've noticed this seems to happen quite a lot: 
> there's a disconnect between the log file and the config which is 
> supposed to have built the kernel.  Is there a bug in your test 
> infrastructure?

sometimes the kernel preceding the currently built one is the buggy one. 
As i have them saved away, so the right one should be:

 http://redhat.com/~mingo/misc/config-Mon_Jun_30_11_03_04_CEST_2008.bad

	Ingo
