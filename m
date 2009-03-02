Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZCBMJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZCBMJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZCBMJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:09:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZCBMJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:09:29 -0500
Date: Mon, 2 Mar 2009 13:08:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090302120859.GB29015@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A907DD.6010408@goop.org>
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

> Ingo Molnar wrote:
>> Personally i'd like to see a sufficient reply to the 
>> mmap-perf paravirt regressions pointed out by Nick and 
>> reproduced by myself as well. (They were in the 4-5% 
>> macro-performance range iirc, which is huge.)
>>
>> So i havent seen any real progress on reducing native kernel 
>> overhead with paravirt. Patches were sent but no measurements 
>> were done and it seemed to have all fizzled out while the 
>> dom0 patches are being pursued.
>>   
>
> Hm, I'm not sure what you want me to do here.  I sent out 
> patches, they got merged, I posted the results of my 
> measurements showing that the patches made a substantial 
> improvement.  I'd love to see confirmation from others that 
> the patches help them, but I don't think you can say I've been 
> unresponsive about this.

Have i missed a mail of yours perhaps? I dont have any track of 
you having posted mmap-perf perfcounters results. I grepped my 
mbox and the last mail i saw from you containing the string 
"mmap-perf" is from January 20, and it only includes my numbers.

What i'd expect you to do is to proactively measure the overhead 
of CONFIG_PARAVIRT overhead of the native kernel, and analyze 
and address the results. Not just minimalistically reply to my 
performance measurements - as that does not really scale in the 
long run.

	Ingo
